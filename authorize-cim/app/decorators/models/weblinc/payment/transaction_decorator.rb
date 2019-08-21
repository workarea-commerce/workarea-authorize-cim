# frozen_string_literal: true
module Weblinc
  decorate Payment::Transaction, with: :cim do
    def refunds
      self.class.successful.refunds.where(reference_id: id)
    end

    def refund_amount
      refunds.to_a.sum(&:amount)
    end
  end
end
