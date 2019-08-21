module Workarea
  module Factories
    module AuthorizeCimFactory
      Factories.add(self)

      def age_capture_or_purchase_transactions_for(payment)
        # force transactions to be older than a day to pass validation
        payment.transactions.each do |transaction|
          transaction.update_attributes!(created_at: transaction.created_at - 2.day)
        end
      end
    end
  end
end
