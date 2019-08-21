# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'weblinc/authorize_cim/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'weblinc-authorize_cim'
  s.version     = Weblinc::AuthorizeCim::VERSION
  s.authors     = ['Tom Scott']
  s.email       = ['tscott@weblinc.com']
  s.homepage    = 'https://www.weblinc.com'
  s.summary     = 'Authorize.Net CIM Integration for WebLinc apps'
  s.description = 'Authorize.Net CIM Integration for WebLinc apps'

  s.files = `git ls-files`.split("\n")

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'weblinc', '~> 2.x'

  s.add_development_dependency 'rubocop', '~> 0'
  s.add_development_dependency 'ci_reporter_rspec', '~> 1'
end
