require 'httparty'

module Messenger

  class Web

    # URL format:
    #     http://example.com
    #
    # The body of the message is posted as the body of the request, not the query.
    def self.send(url, body, options={})
      response = HTTParty.post(url, options.merge(:body => body))
      [success?(response), response]
    end

  private

    def self.success?(response)
      case response.code
      when 200, 201: true
      else
        false
      end
    end

  end

end
