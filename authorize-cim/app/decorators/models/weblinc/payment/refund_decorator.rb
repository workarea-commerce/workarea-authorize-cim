# frozen_string_literal: true
module Weblinc
  decorate Payment::Refund, with: :cim do
    def find_reference_transactions_for(tender)
      tender.transactions.successful.captures.select do |trans|
        trans.refund_amount.to_m < trans.captured_amount.to_m
      end
    end
  end
end
