# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fh/api/version'

Gem::Specification.new do |spec|
  spec.name          = "fh-api"
  spec.version       = Fh::Api::VERSION
  spec.authors       = ["Joe Sak"]
  spec.email         = ["joe@joesak.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec',   '~> 2.13.0'
  spec.add_development_dependency 'vcr',     '~> 2.4.0'
  spec.add_development_dependency 'webmock', '~> 1.13.0'
  spec.add_development_dependency 'pry',     '~> 0.9.12'

  spec.add_dependency 'oauth', '~> 0.4.7'
end
