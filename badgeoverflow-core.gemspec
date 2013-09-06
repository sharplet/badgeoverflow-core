# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'badgeoverflow/core/version'

Gem::Specification.new do |spec|
  spec.name          = "badgeoverflow-core"
  spec.version       = Badgeoverflow::Core::VERSION
  spec.authors       = ["Adam Sharp", "Stephanie Sharp"]
  spec.email         = ["adsharp@me.com", "stephrsharp@gmail.com"]
  spec.summary       = "Service layer for the BadgeOverflow dashboard."
  spec.description   = "#{spec.description}"
  spec.homepage      = "https://github.com/stephsharp/badgeoverflow"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sanitize", "~> 2.0.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
