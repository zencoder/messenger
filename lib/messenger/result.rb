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

  end

end
