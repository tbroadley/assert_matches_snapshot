# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assert_matches_snapshot/version'

Gem::Specification.new do |spec|
  spec.name          = "assert_matches_snapshot"
  spec.version       = AssertMatchesSnapshot::VERSION
  spec.authors       = ["Thomas Broadley"]
  spec.email         = ["buriedunderbooks@hotmail.com"]

  spec.summary       = %q{An assertion for snapshot testing.}
  spec.homepage      = "https://github.com/tbroadley/assert-matches-snapshot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "guard", "~> 2.10"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "fakefs", "~> 0.10"
end
