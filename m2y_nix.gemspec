require_relative 'lib/m2y_nix/version'

Gem::Specification.new do |spec|
  spec.name          = "m2y_nix"
  spec.version       = M2yNix::VERSION
  spec.authors       = ["Guillaume"]
  spec.email         = ["guillaume.zeldine@mobile2you.com.br"]

  spec.summary       = %q{Nix API Gem}
  spec.description   = %q{Nix API Gem}
  spec.homepage      = "http://www.mobile2you.com.br"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "httparty", "~> 0.20.0"
  spec.add_runtime_dependency "openssl"
end
