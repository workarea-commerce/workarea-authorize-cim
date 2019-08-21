# frozen_string_literal: true
module Weblinc
  decorate Payment::Profile, with: :cim do
    decorated do
      include Mongoid::Publisher

      before_validation :create_gateway_profile, if: :needs_gateway_profile?, on: :create
      before_destroy :delete_gateway_profile, if: :on_gateway?
    end

    protected

    # Create a new payment profile on the gateway, and log an error when
    # this cannot be accomplished. First, this checks to make sure a
    # +Payment::Profile+ doesn't already exist locally for the current
    # email. If that is true, we attempt to either find an existing
    # profile on Authorize.net or create a new one. Eventually,
    # +gateway_id+ should be set to something after this method is
    # called, and if not, a validation error is logged.
    #
    # @protected
    # @return [Boolean] +true+
    def create_gateway_profile
      self.gateway_id = previous_profile_id || remote_profile_id
      errors.add :gateway, 'error occurred' unless gateway_id.present?
    end

    # When destroying this record, also delete the payment profile from
    # Authorize.net.
    #
    # @protected
    # @return [Boolean] whether the operation was successful
    def delete_gateway_profile
      gateway.delete_customer_profile(
        customer_profile_id: gateway_id
      ).tap do |response|
        errors.add :response, response.inspect unless response.success?
      end.success?
    end

    # Test whether we need to ask Authorize.Net for a payment profile.
    #
    # @protected
    # @return [Boolean] whether we need a payment profile
    def needs_gateway_profile?
      email.present? && gateway_id.blank?
    end

    # Test whether we have a gateway ID.
    #
    # @protected
    # @return [Boolean]
    def on_gateway?
      gateway_id.present?
    end

    private

    # The credit card gateway we're using to communicate with
    # Authorize.Net
    #
    # @private
    # @return [ActiveMerchant::Billing::Gateway]
    def gateway
      Weblinc.config.gateways.credit_card
    end

    # Find an existing +Payment::Profile+ record with a gateway_id for
    # this User, and use it in this record to save a roundtrip to
    # Authorize.Net.
    #
    # @private
    # @return [String] or +nil+ if none can be found.
    def previous_profile_id
      @ppid ||= Weblinc::Payment::Profile.where(
        email: email,
        :gateway_id.ne => nil
      ).pluck(:gateway_id).first
    end

    # Attempt to create a new customer profile on Authorize.Net, either
    # by doing it outright or going through the duplicate payment
    # profile motions.
    #
    # @private
    # @return [String] The new payment profile ID from Authorize.net or
    # +nil+ if it cannot be created.
    def remote_profile_id
      response = gateway.create_customer_profile(profile: { email: email })
      return response.params['customer_profile_id'] if response.success?
      return duplicate_payment_profile_id(response) if duplicate_profile?(response)
      raise Payment::CreateProfileError.new(
        response.message,
        parameters: {
          email: email,
          response: debug_response(response)
        }
      )
    end

    # Attempt to pull the existing customer profile Authorize.Net using
    # the original response's message and another API call.
    #
    # @private
    # @param original_response [ActiveMerchant::Billing::Response]
    # @return [String] Existing profile ID for this user
    # @raise [Payment::CreateProfileError] if still can't be created.
    def duplicate_payment_profile_id(original_response)
      gateway_id = get_id_from_message(original_response)
      response = gateway.get_customer_profile(customer_profile_id: gateway_id)

      if response.success? && email_match?(response)
        gateway_id
      else
        raise Payment::CreateProfileError, response.message
      end
    end

    # Test whether the email in this response matches the email in the
    # +Payment::Profile+ we're trying to create, so as not to
    # accidentally assign the wrong gateway_id to the wrong user.
    #
    # @private
    # @param response [ActiveMerchant::Billing::Response]
    # @return [Boolean] whether the email matches
    def email_match?(response)
      response.params['profile']['email'] == email
    end

    # Test whether the response's error code matches the duplicate
    # profile creation error code of +E00039+, which triggers a lookup
    # in the error message of the payment profile ID.
    #
    # @private
    # @param response [ActiveMerchant::Billing::Response]
    # @return [Boolean] whether the error code matches E00039
    def duplicate_profile?(response)
      response.params['messages'].try(:[], 'message').try(:[], 'code') == 'E00039'
    end

    # Attempt to parse out the gateway ID from the error message that is
    # given for duplicate record creation.
    #
    # @private
    # @param response [ActiveMerchant::Billing::Response]
    # @return [String] ID of the existing profile.
    def get_id_from_message(response)
      text = response.params['messages']['message']['text']
      return unless text.present?
      text.match(/A duplicate record with ID (\d+) already exists/)[1]
    end

    # Picks out the relevant pieces of the ActiveMerchant response for
    # an exception object.
    #
    # @private
    # @param response [ActiveMerchant::Billing::Response]
    # @return [Hash]
    def debug_response(response)
      {
        authorization: response.authorization,
        avs_result: response.avs_result,
        cvv_result: response.cvv_result,
        error_code: response.error_code,
        message: response.message,
        params: response.params,
        test: response.test
      }
    end
  end
end
