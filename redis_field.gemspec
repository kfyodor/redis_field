# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_field/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_field"
  spec.version       = RedisField::VERSION
  spec.authors       = ["Theodore Konukhov"]
  spec.email         = ["komolov.f@gmail.com"]
  spec.summary       = %q{Redis attributes in ActiveRecord models}
  spec.description   = %q{This gem allows you to easily use Redis to store data as regular ActiveRecord attributes}
  spec.homepage      = "http://theodore.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 3.2'
  spec.add_dependency 'redis'
  spec.add_dependency 'redis-namespace'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end