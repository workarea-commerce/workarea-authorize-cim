# frozen_string_literal: true
require 'spec_helper'

module Weblinc
  class Payment
    class Refund
      describe CreditCard do
        let(:capture) do
          gateway = ActiveMerchant::Billing::BogusAuthorizeNetCimGateway.new
          gateway.create_customer_profile_transaction(
            transaction: {
              type: :prior_auth_capture,
              amount: 5.00,
              trans_id: '0'
            }
          )
        end

        let(:profile) { create_payment_profile }

        let(:payment) { create_payment(profile: profile) }

        let(:tender) do
          payment.set_address(first_name: 'Ben', last_name: 'Crouse')
          payment.build_credit_card(
            number: 1,
            month: 1,
            year: Time.now.year + 1,
            cvv: 999
          )

          payment.credit_card
        end

        let(:reference) do
          tender.transactions.build(
            amount: 5.to_m,
            response: capture,
            action: 'capture',
            created_at: Time.now - 2.days
          )
        end
        let(:transaction) do
          tender.transactions.build(
            amount: 5.to_m,
            reference: reference,
            action: 'refund'
          )
        end

        describe '#complete!' do
          it 'raises if the reference transaction is blank' do
            transaction.reference = nil
            operation = CreditCard.new(tender, transaction)

            expect { operation.complete! }
              .to raise_error(Payment::MissingReference)
          end

          it 'refunds on the credit card gateway' do
            operation = CreditCard.new(tender, transaction)

            expect(Weblinc.config.gateways.credit_card)
              .to receive(:create_customer_profile_transaction_for_refund)
              .and_call_original

            operation.complete!
          end

          it 'sets the response on the transaction' do
            operation = CreditCard.new(tender, transaction)
            operation.complete!

            expect(transaction.response)
              .to be_an_instance_of(ActiveMerchant::Billing::Response)
          end
        end
      end
    end
  end
end
