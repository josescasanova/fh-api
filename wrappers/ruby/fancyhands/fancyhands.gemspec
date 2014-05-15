# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fancyhands/version'

Gem::Specification.new do |spec|
  spec.name          = "fancyhands"
  spec.version       = Fancyhands::VERSION
  spec.authors       = ["Joe Sak", "Jose Casanova"]
  spec.email         = ["joe@joesak.com", "jose@josecasanova.com"]
  spec.summary       = %q{A simple ruby wrapper for Fancyhands API}
  spec.homepage      = "https://github.com/josescasanova/fh-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec',   '~> 2.13.0'
  spec.add_development_dependency 'vcr',     '~> 2.4.0'
  spec.add_development_dependency 'webmock', '< 1.10'
  spec.add_development_dependency 'pry',     '~> 0.9.12'

  spec.add_dependency 'oauth', '~> 0.4.7'
end
