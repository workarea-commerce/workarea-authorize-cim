# frozen_string_literal: true
module Weblinc
  decorate Payment, with: :cim do
    def successful_captures
      transactions.select { |tran| tran.capture? && tran.success? }
    end

    def eligible_for_refund?
      return true unless credit_card?
      successful_captures.first.created_at < Time.now - 24.hours
    end
  end
end
