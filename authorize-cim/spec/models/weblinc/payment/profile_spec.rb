# frozen_string_literal: true
require 'spec_helper'

module Weblinc
  class Payment
    describe Profile do
      let(:user) { create_user }
      let(:reference) { PaymentReference.new(user) }
      subject(:profile) { Profile.lookup(reference) }

      describe '#default_credit_card' do
        it 'returns the card marked as default' do
          default = create_saved_credit_card(profile: profile, default: true)
          create_saved_credit_card(profile: profile, default: false)
          expect(profile.default_credit_card).to eq(default)
        end

        it 'when no default, returns the most recently created' do
          default = create_saved_credit_card(profile: profile)
          create_saved_credit_card(profile: profile, created_at: Time.now - 1.hour)
          expect(profile.default_credit_card).to eq(default)
        end
      end

      describe '#purchase_on_store_credit' do
        before { profile.update_attributes(store_credit: 10.to_m) }

        it 'subtracts the amount from the store credit' do
          profile.purchase_on_store_credit(500)
          profile.reload

          expect(profile.store_credit).to eq(5.to_m)
        end

        it 'raises if there are insufficient funds' do
          expect do
            profile.purchase_on_store_credit(5000)
          end.to raise_error(InsufficientFunds)
        end
      end

      describe '#reload_store_credit' do
        before { profile.update_attributes(store_credit: 0.to_m) }

        it 'adds the amount to the store credit' do
          profile.reload_store_credit(500)
          profile.reload

          expect(profile.store_credit).to eq(5.to_m)
        end
      end

      describe '#remote_profile_id' do
        # NOTE: I spent like 3 hours trying to write tests for this that
        # covered every aspect, but couldn't deal with all the code
        # dependencies. One day, I'd like to return to this method and
        # contribute a test suite of some kind, but today is not that
        # day.

        let :profile_id do
          '666666666666'
        end

        let :response do
          double(
            success?: false,
            authorization: '',
            avs_result: '',
            cvv_result: '',
            error_code: 'E00039',
            message: 'test',
            test: true,
            params: {
              'messages' => {
                'message' => {
                  'code' => 'E00039',
                  'text' => "A duplicate record with ID #{profile_id} already exists."
                }
              }
            }
          )
        end

        it 'tests duplicate profile' do
          expect { profile.send(:remote_profile_id) }.not_to raise_error
          expect(profile.send(:remote_profile_id)).to be_present
          expect(profile.send(:remote_profile_id)).to be_a(String)
        end

        it 'finds duplicate payment profile id if error message contains response' do
          lookup = { profile: { email: user.email } }

          allow(profile.send(:gateway)).to \
            receive(:duplicate_profile?).with(response).and_return(true)
          allow(profile.send(:gateway)).to \
            receive(:create_customer_profile).with(lookup).and_return(response)
          allow(profile.send(:gateway)).to \
            receive(:get_customer_profile).with(customer_profile_id: profile_id)
            .and_return(double(success?: true, params: { 'profile' => { 'email' => user.email } }))

          expect(profile.send(:remote_profile_id)).to eq profile_id
        end
      end
    end
  end
end
