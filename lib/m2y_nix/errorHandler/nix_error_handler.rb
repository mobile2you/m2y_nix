module ErrorEnum
 UnknownError = 0
 InputError = 1
 NotFound = 2
 BadRequest = 3
end

module NixMappedErrors
 InputError = "MethodArgumentNotValidException"
 NotFoundPIER = "NotFoundExceptionPIER"
 BadRequestPIER = "BadRequestExceptionPIER"
end

module M2yNix
 class NixErrorHandler
     attr_accessor :errorType, :message, :reasons, :status, :nixStatus

     def initialize()
         @errorType = nil
         @message = ""
         @reasons = []
         @status = 400
         @nixStatus = 0
     end

     def to_json()
         json = {
             errorType: @errorType,
             message: @message,
             reasons: @reasons,
             status: @status,
             nixStatus: @nixStatus
         }
         json
     end

     def mapErrorType(nixResponse)
         @message = ""
         @errorType = nil
         hasError = false
         
         if nixResponse.class == Hash
             if !nixResponse['exception'].nil?
                 hasError = true
                 @message = nixResponse['exception']
                 case nixResponse['exception']
                 when NixMappedErrors::InputError
                     @errorType = ErrorEnum::InputError
                     @status = 422
                 when NixMappedErrors::NotFoundPIER
                     @errorType = ErrorEnum::NotFound
                     @status = 404
                 when NixMappedErrors::BadRequestPIER
                     @errorType = ErrorEnum::BadRequest
                     @status = 400
                 else
                     @errorType = ErrorEnum::UnknownError
                 end
                 if !nixResponse[:code].nil?
                     @nixStatus = nixResponse[:code]
                 elsif !nixResponse[:status].nil?
                     @nixStatus = nixResponse[:status]
                 end
                 generateReasons(nixResponse)
             elsif !nixResponse[:message].nil? and !nixResponse[:message].downcase.include? "success"
                 hasError = true
                 @message = nixResponse[:message]
             elsif !nixResponse[:error].nil?
                 hasError = true
                 @message = nixResponse[:message]
                 generateReasons(nixResponse)
                 @errorType = ErrorEnum::UnknownError
             end
         end
         hasError
     end

     def generateReasons(nixResponse)
         @reasons = []
         if !nixResponse[:erros].nil?
             nixResponse[:erros].each do |error|
                 reasonMessage = ""
                 if !error["field"].nil?
                     reasonMessage += error["field"]
                 end
                 if !error["defaultMessage"].nil?
                     reasonMessage += " " + error["defaultMessage"]
                 end
                 # puts error["code"]
                 reason = { message: reasonMessage, nixCode: error["code"] }
                 @reasons << reason
             end
         elsif !nixResponse[:message].nil?
             @reasons << nixResponse[:message]
         elsif !nixResponse[:error].nil?
             @reasons << nixResponse[:error]
         end
     end
 end
end



