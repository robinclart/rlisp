
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rlisp/version"

Gem::Specification.new do |spec|
  spec.name          = "rlisp"
  spec.version       = Rlisp::VERSION
  spec.authors       = ["Robin Clart"]
  spec.email         = ["robin@clart.be"]

  spec.summary       = "A Lisp in Ruby"
  spec.homepage      = "https://github.com/robinclart/rlisp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
