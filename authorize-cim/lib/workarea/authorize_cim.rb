# frozen_string_literal: true

require 'workarea'

require 'workarea/authorize_cim/engine'
require 'workarea/authorize_cim/version'
require 'workarea/authorize_cim/error'

require 'active_merchant/billing/bogus_authorize_net_cim_gateway'

module Workarea
  module AuthorizeCim
    # Credentials for Authorize.Net from Rails secrets.
    #
    # @return [Hash]
    def self.credentials
      return {} unless Rails.application.secrets.authorize.present?
      Rails.application.secrets.authorize.symbolize_keys
    end

    # Conditionally use the real gateway when secrets are present.
    # Otherwise, use the bogus gateway.
    #
    # @return [ActiveMerchant::Billing::Gateway]
    def self.gateway
      Workarea.config.gateways.credit_card
    end

    def self.gateway=(gateway)
      Workarea.config.gateways.credit_card = gateway
    end

    def self.auto_initialize_gateway
      if credentials.present?
        if ENV['HTTP_PROXY'].present?
          uri = URI.parse(ENV['HTTP_PROXY'])
          ActiveMerchant::Billing::AuthorizeNetCimGateway.proxy_address = uri.host
          ActiveMerchant::Billing::AuthorizeNetCimGateway.proxy_port = uri.port
        end

        self.gateway = ActiveMerchant::Billing::AuthorizeNetCimGateway.new credentials
      else
        self.gateway = ActiveMerchant::Billing::BogusAuthorizeNetCimGateway.new
      end
    end
  end
end
