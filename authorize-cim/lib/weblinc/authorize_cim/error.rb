module Weblinc
  module AuthorizeCim
    class Error < StandardError
      def initialize(params)
        @code = params['message']['code']
        @text = params['message']['text']

        super "#{@text} (#{@code})"
      end
    end
  end
end