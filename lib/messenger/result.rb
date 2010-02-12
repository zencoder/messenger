module Messenger

  class Result

    attr_reader :response_code, :response_headers, :response_body

    def initialize(success, options={})
      @success = success
      @response_code = options[:code]
      @response_headers = options[:headers]
      @response_body = options[:body]
    end

    def success?
      !!@success
    end

  end

end
