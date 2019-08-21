# frozen_string_literal: true
module Weblinc
  decorate Payment::Capture::CreditCard, with: :cim do
    def complete!
      validate_reference!

      transaction.response = handle_active_merchant_errors do
        gateway.create_customer_profile_transaction(
          transaction = capture_args
        )
      end
    end

    def cancel!
      # noop, can't cancel a capture
    end

    private

    def capture_args
      {
        transaction: {
          type: :prior_auth_capture,
          amount: auth_amount,
          trans_id: transaction_ref_id
        }
      }
    end

    def transaction_ref_id
      transaction.reference.response.params['direct_response']['transaction_id']
    end

    # cim requires dollar amount (not cents)
    # eg $4.25
    def auth_amount
      transaction.amount.to_s.to_f
    end
  end
end
