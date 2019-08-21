require_relative 'boot'

require 'action_controller/railtie'
require 'action_mailer/railtie'
require "rails/test_unit/railtie"
require 'sprockets/railtie'

# Workarea must be required before other gems to ensure control over Rails.env
# for running tests
require 'workarea/core'
require 'workarea/admin'
require 'workarea/storefront'
require 'workarea/authorize_cim'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
  end
end
