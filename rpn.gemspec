# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpn/version'

Gem::Specification.new do |spec|
  spec.name          = "rpn"
  spec.version       = RPN::VERSION
  spec.authors       = ["Jim Whiteman"]
  spec.email         = ["jimtron9000@gmail.com"]

  spec.summary       = %q{RPN for On-Site.}
  spec.description   = %q{RPN for On-Site.}
  spec.homepage      = "https://github.com/jwhiteman/rpn"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
