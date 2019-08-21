# frozen_string_literal: true
require 'weblinc'
require 'active_merchant/billing/bogus_authorize_net_cim_gateway'

module Weblinc
  module AuthorizeCim
    class Engine < ::Rails::Engine
      include Weblinc::Plugin
      isolate_namespace Weblinc::AuthorizeCim

      initializer 'weblinc.authorize_cim' do
        Weblinc.configure do |config|
          unless config.authorize_gateway_class.present?
            secrets = Rails.application.secrets.authorize || {}
            config.authorize_gateway_class = \
              if secrets.any?
                ActiveMerchant::Billing::AuthorizeNetCimGateway
              else
                ActiveMerchant::Billing::BogusAuthorizeNetCimGateway
              end
            config.gateways.credit_card = config.authorize_gateway_class.new(
              secrets.symbolize_keys.merge(test: false)
            )
          end
        end
      end
    end
  end
end
