# frozen_string_literal: true
module Weblinc
  decorate Payment::Tender::CreditCard, with: :cim do
    decorated do
      field :ip_address, type: String
      delegate :number, to: :order, prefix: true
    end

    # @return [String]
    def gateway_profile_id
      profile.gateway_id
    end

    def valid_capture_date?
      payment.eligible_for_refund?.tap do |eligible|
        unless eligible
          payment.errors.add(
            :base,
            'The initial charge has not yet been settled.' \
            'A transaction must be settled before you can issue a refund.'
          )
        end
      end
    end

    private

    def ensure_payment_profile
      profile.save
    end
  end
end
