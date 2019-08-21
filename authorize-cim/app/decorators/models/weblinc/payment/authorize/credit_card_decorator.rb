# frozen_string_literal: true
module Weblinc
  decorate Payment::Authorize::CreditCard, with: :cim do
    def complete!
      # Some gateways will tokenize in the same request as the authorize.
      # If that is the case for the gateway you are implementing, omit the
      # following line, and save the token on the tender after doing the
      # gateway authorization.

      return unless Weblinc::Payment::StoreCreditCard.new(tender, options).save!
      transaction.response = handle_active_merchant_errors do
        gateway.create_customer_profile_transaction(
          transaction = auth_args
        )
      end
    end

    def cancel!
      return unless transaction.success?

      transaction.cancellation = handle_active_merchant_errors do
        gateway.create_customer_profile_transaction(
          transaction = void_args
        )
      end
    end

    private

    def auth_args
      {
        transaction: {
          type: :auth_only,
          customer_profile_id: customer_profile_id,
          customer_payment_profile_id: customer_payment_profile_id,
          amount: auth_amount
        }
      }
    end

    def void_args
      {
        transaction: {
          type: :void,
          customer_profile_id: customer_profile_id,
          customer_payment_profile_id: customer_payment_profile_id,
          trans_id: transaction.response.authorization
        }
      }
    end

    def customer_profile_id
      tender.gateway_profile_id
    end

    def customer_payment_profile_id
      tender.token
    end

    # cim requeires dollar amount (not cents)
    # eg $4.25
    def auth_amount
      tender.amount.cents / 100.00
    end
  end
end
