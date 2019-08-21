# frozen_string_literal: true

module ActiveMerchant
  module Billing
    class BogusAuthorizeNetCimGateway < BogusGateway
      SUCCESS_PAYMENT_PROFILE_ID = '111111'
      FAILURE_PAYMENT_PROFILE_ID = '222222'
      ERROR_PAYMENT_PROFILE_ID   = '333333'

      def initialize(*args)
        super
        @test = true
      end

      def find_customer_profile_id
        "1#{SecureRandom.random_number(100_000)}"
      end

      def create_customer_profile(_options)
        profile_id = find_customer_profile_id
        params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } }, 'customer_profile_id' => profile_id, 'customer_payment_profile_id_list' => nil, 'customer_shipping_address_id_list' => nil, 'validation_direct_response_list' => nil }
        Response.new(true, SUCCESS_MESSAGE, params, test: true)
      end

      def create_customer_payment_profile(options)
        card = options[:payment_profile][:payment][:credit_card]
        params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } } }

        case card.number
        when /1$/
          Response.new(true, SUCCESS_MESSAGE, params.merge('customer_payment_profile_id' => SUCCESS_PAYMENT_PROFILE_ID), test: true)
        when /2$/
          Response.new(false, SUCCESS_MESSAGE, params.merge('customer_payment_profile_id' => FAILURE_PAYMENT_PROFILE_ID), test: true)
        else
          Response.new(false, SUCCESS_MESSAGE, params.merge('customer_payment_profile_id' => ERROR_PAYMENT_PROFILE_ID), test: true)
        end
      end

      def create_customer_shipping_address(options); end

      def delete_customer_profile(_options)
        params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } } }
        Response.new(true, SUCCESS_MESSAGE, params, test: true)
      end

      def delete_customer_payment_profile(options); end

      def delete_customer_shipping_address(options); end

      def get_customer_profile(options)
        params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } }, 'profile' => { 'email' => 'user@workarea.com', 'customer_profile_id' => options[:customer_profile_id], 'payment_profiles' => nil } }
        Response.new(true, SUCCESS_MESSAGE, params, test: true)
      end

      def get_customer_profile_ids(options = {}); end

      def get_customer_payment_profile(_options)
        params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } }, 'payment_profile' => { 'customer_payment_profile_id' => '8619844', 'payment' => { 'credit_card' => { 'card_number' => 'XXXX1111', 'expiration_date' => 'XXXX' } } } }
        Response.new(true, SUCCESS_MESSAGE, params, test: true)
      end

      def get_customer_shipping_address(options); end

      def update_customer_profile(options); end

      def update_customer_payment_profile(_options)
        params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } } }
        Response.new(true, SUCCESS_MESSAGE, params, test: true)
      end

      def update_customer_shipping_address(options); end

      def create_customer_profile_transaction(options)
        payment_profile_id = options[:transaction][:customer_payment_profile_id]

        unless payment_profile_id.nil? || payment_profile_id =~ /^1/ || payment_profile_id =~ /^2/
          raise Error, NUMBER_ERROR_MESSAGE
        end

        if payment_profile_id =~ /^1/ || payment_profile_id.nil?
          params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } }, 'direct_response' => { 'raw' => '1,1,1,(TESTMODE) This transaction has been approved.,000000,P,0,,,77.49,CC,auth_only,,,,,,,,,,,,bcrouse@workarea.com,,,,,,,,,,,,,,F6000E62F2517691DED641D62E1B0FD8,,,,,,,,,,,,,XXXX5100,MasterCard,,,,,,,,,,,,,,,,', 'response_code' => '1', 'response_subcode' => '1', 'response_reason_code' => '1', 'message' => '(TESTMODE) This transaction has been approved.', 'approval_code' => '000000', 'avs_response' => 'P', 'transaction_id' => '0', 'invoice_number' => '', 'order_description' => '', 'amount' => '77.49', 'method' => 'CC', 'transaction_type' => 'auth_only', 'customer_id' => '', 'first_name' => '', 'last_name' => '', 'company' => '', 'address' => '', 'city' => '', 'state' => '', 'zip_code' => '', 'country' => '', 'phone' => '', 'fax' => '', 'email_address' => 'bcrouse@workarea.com', 'ship_to_first_name' => '', 'ship_to_last_name' => '', 'ship_to_company' => '', 'ship_to_address' => '', 'ship_to_city' => '', 'ship_to_state' => '', 'ship_to_zip_code' => '', 'ship_to_country' => '', 'tax' => '', 'duty' => '', 'tax_exempt' => '', 'purchase_order_number' => '', 'md5_hash' => 'F6000E62F2517691DED641D62E1B0FD8', 'card_code' => '', 'cardholder_authentication_verification_response' => '', 'account_number' => 'XXXX5100', 'card_type' => 'MasterCard', 'split_tender_id' => '', 'requested_amount' => '', 'balance_on_card' => '' } }
          Response.new(true, SUCCESS_MESSAGE, params, test: true, authorization: AUTHORIZATION)
        else
          params = { 'messages' => { 'result_code' => 'FAILURE', 'message' => { 'code' => 'BOGUS_FAIL', 'text' => 'Failure.' } }, 'direct_response' => { 'raw' => '1,1,1,(TESTMODE) This transaction has been declined.,000000,P,0,,,77.49,CC,auth_only,,,,,,,,,,,,bcrouse@workarea.com,,,,,,,,,,,,,,F6000E62F2517691DED641D62E1B0FD8,,,,,,,,,,,,,XXXX5100,MasterCard,,,,,,,,,,,,,,,,', 'response_code' => '1', 'response_subcode' => '1', 'response_reason_code' => '1', 'message' => FAILURE_MESSAGE, 'approval_code' => '000000', 'avs_response' => 'P', 'transaction_id' => '0', 'invoice_number' => '', 'order_description' => '', 'amount' => '77.49', 'method' => 'CC', 'transaction_type' => 'auth_only', 'customer_id' => '', 'first_name' => '', 'last_name' => '', 'company' => '', 'address' => '', 'city' => '', 'state' => '', 'zip_code' => '', 'country' => '', 'phone' => '', 'fax' => '', 'email_address' => 'bcrouse@workarea.com', 'ship_to_first_name' => '', 'ship_to_last_name' => '', 'ship_to_company' => '', 'ship_to_address' => '', 'ship_to_city' => '', 'ship_to_state' => '', 'ship_to_zip_code' => '', 'ship_to_country' => '', 'tax' => '', 'duty' => '', 'tax_exempt' => '', 'purchase_order_number' => '', 'md5_hash' => 'F6000E62F2517691DED641D62E1B0FD8', 'card_code' => '', 'cardholder_authentication_verification_response' => '', 'account_number' => 'XXXX5100', 'card_type' => 'MasterCard', 'split_tender_id' => '', 'requested_amount' => '', 'balance_on_card' => '' } }
          Response.new(false, FAILURE_MESSAGE, params, test: true)
        end
      end

      def create_customer_profile_transaction_for_refund(_options)
        response_params = { 'messages' => { 'result_code' => 'Ok', 'message' => { 'code' => 'I00001', 'text' => 'Successful.' } }, 'direct_response' => { 'raw' => '1,1,1,This transaction has been approved.,,P,2246535996,,,10.00,CC,credit,,Jon,Bytof,workarea,100 Market St,Philadelphia,PA,19106,US,2154503048,,jbytof+tahari@workarea.com,,,,,,,,,,,,,,CD971B50C98175583C8F4BB1FECE7215,,,,,,,,,,,,,XXXX0015,MasterCard,,,,,,,,,,,,,,,,', 'response_code' => '1', 'response_subcode' => '1', 'response_reason_code' => '1', 'message' => 'This transaction has been approved.', 'approval_code' => '', 'avs_response' => 'P', 'transaction_id' => '2246535996', 'invoice_number' => '', 'order_description' => '', 'amount' => '10.00', 'method' => 'CC', 'transaction_type' => 'credit', 'customer_id' => '', 'first_name' => 'Jon', 'last_name' => 'Bytof', 'company' => 'workarea', 'address' => '100 Market St', 'city' => 'Philadelphia', 'state' => 'PA', 'zip_code' => '19106', 'country' => 'US', 'phone' => '2154503048', 'fax' => '', 'email_address' => 'jbytof+tahari@workarea.com', 'ship_to_first_name' => '', 'ship_to_last_name' => '', 'ship_to_company' => '', 'ship_to_address' => '', 'ship_to_city' => '', 'ship_to_state' => '', 'ship_to_zip_code' => '', 'ship_to_country' => '', 'tax' => '', 'duty' => '', 'freight' => '', 'tax_exempt' => '', 'purchase_order_number' => '', 'md5_hash' => 'CD971B50C98175583C8F4BB1FECE7215', 'card_code' => '', 'cardholder_authentication_verification_response' => '', 'account_number' => 'XXXX0015', 'card_type' => 'MasterCard', 'split_tender_id' => '', 'requested_amount' => '', 'balance_on_card' => '' } }
        Response.new(true, SUCCESS_MESSAGE, response_params, test: true, authorization: AUTHORIZATION)
      end

      def create_customer_profile_transaction_for_void(options); end

      def validate_customer_payment_profile(options); end
    end
  end
end
