# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'workarea/authorize_cim/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'workarea-authorize_cim'
  s.version     = Workarea::AuthorizeCim::VERSION
  s.authors     = ['Tom Scott']
  s.email       = ['tscott@workarea.com']
  s.homepage    = 'https://www.workarea.com'
  s.summary     = 'Authorize.Net CIM Integration for WorkArea'
  s.description = 'Authorize.Net CIM Integration for WorkArea'

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'workarea', '~> 3.x'

  s.add_development_dependency 'rubocop', '~> 0'
end
