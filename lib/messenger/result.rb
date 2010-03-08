module Messenger

  class Result

    attr_reader :response

    def initialize(success, response)
      @success = success
      @response = response
    end

    def success?
      !!@success
    end

    def code
      response.code rescue nil
    end

    def body
      if response.respond_to?(:body)
        response.body
      else
        response
      end
    end

  end

end
