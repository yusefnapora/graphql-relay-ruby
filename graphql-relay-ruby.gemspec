# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'relay/version'

Gem::Specification.new do |spec|
  spec.name          = "graphql-relay-ruby"
  spec.version       = Relay::VERSION
  spec.authors       = ["Yusef Napora"]
  spec.email         = ["yusef@napora.org"]

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "codeclimate-test-reporter", '~>0.4'
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "guard-bundler", "~> 2.1"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "minitest-focus", "~> 1.1"
  spec.add_development_dependency "minitest-reporters", "~>1.0"
  spec.add_development_dependency "rake", "~> 10.4"

  spec.add_runtime_dependency 'graphql'
end
