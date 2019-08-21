decorate ActiveMerchant::Billing::AuthorizeNetCimGateway, with: :workarea do
  def build_create_customer_profile_transaction_request(xml, options)
    options[:extra_options] ||= {}
    options[:extra_options].merge!('x_delim_char' => @options[:delimiter]) if @options[:delimiter]
    options[:extra_options].merge!('x_duplicate_window' => 0)

    add_transaction(xml, options[:transaction])
    xml.tag!('extraOptions') do
      xml.cdata!(format_extra_options(options[:extra_options]))
    end unless options[:extra_options].blank?

    xml.target!
  end
end
