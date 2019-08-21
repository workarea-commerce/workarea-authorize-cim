# frozen_string_literal: true
module Weblinc
  class Payment
    # Thrown when Authorize.net can't create the payment profile for
    # some reason. This is typically caught and hidden from erroring out
    # to the user, instead preferring to notify the developers of the
    # issue via a reporting service.
    #
    # The web application will defer to the frontend to actually report
    # this error to the user.
    class CreateProfileError < StandardError
      def initialize(message, parameters: {})
        @parameters = parameters
        super "Payment profile could not be created: #{message}"
      end
    end
  end
end
