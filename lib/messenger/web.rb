require 'httparty'

module Messenger

  class Web

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
