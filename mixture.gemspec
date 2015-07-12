# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mixture/version"

Gem::Specification.new do |spec|
  spec.name          = "mixture"
  spec.version       = Mixture::VERSION
  spec.authors       = ["Jeremy Rodi"]
  spec.email         = ["redjazz96@gmail.com"]

  spec.summary       = "Handle validation, coercion, and attributes."
  spec.description   = "Handle validation, coercion, and attributes."
  spec.homepage      = "https://github.com/medcat/mixture"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files
    .grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "thread_safe", "~> 0.3"
end
