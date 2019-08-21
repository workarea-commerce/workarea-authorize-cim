# frozen_string_literal: true

require 'test_helper'

module Workarea
  class Payment
    class ProfileTest < TestCase
      def setup
        @user = create_user
        @reference = PaymentReference.new @user
        @profile = Profile.lookup @reference
      end

      def test_default_credit_card
        default = create_saved_credit_card(profile: @profile, default: true)
        create_saved_credit_card(profile: @profile, default: false)

        assert_equal(default, @profile.default_credit_card)
      end

      def test_default_credit_card_one_hour_ago
        default = create_saved_credit_card profile: @profile
        create_saved_credit_card(profile: @profile, created_at: Time.now - 1.hour)

        assert_equal default, @profile.default_credit_card
      end

      def test_purchase_on_store_credit
        @profile.update_attributes(store_credit: 10.to_m)
        @profile.purchase_on_store_credit(500)
        @profile.reload

        assert_equal 5.to_m, @profile.store_credit

        assert_raises InsufficientFunds do
          @profile.purchase_on_store_credit(5000)
        end
      end

      def test_reload_store_credit
        @profile.update_attributes(store_credit: 0.to_m)
        @profile.reload_store_credit(500)
        @profile.reload

        assert_equal 5.to_m, @profile.store_credit
      end

      def test_duplicate_profile
        remote_profile_id = @profile.send :remote_profile_id

        assert remote_profile_id.present?
        assert_kind_of String, remote_profile_id
      end

      def test_find_duplicate_payment_profile_id
        assert_match(/\A\d{5}/, @profile.send(:remote_profile_id))
      end
    end
  end
end
