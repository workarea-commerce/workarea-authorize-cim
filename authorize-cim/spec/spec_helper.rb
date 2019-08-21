# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'

require "#{File.dirname(__FILE__)}/dummy/config/environment"
require 'weblinc/testing/spec_helper'

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = 'random'
end
