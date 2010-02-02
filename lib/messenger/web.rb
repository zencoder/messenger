require 'httparty'

module Messenger

  class Web

    def self.send(url, body, options={})
      HTTParty.post(url, options.merge(:body => body))
    end

  end

end
