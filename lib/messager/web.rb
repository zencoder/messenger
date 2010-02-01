require 'httparty'

module Messager

  class Web

    def self.send(url, body, options={})
      HTTParty.post(url, :body => body)
    end

  end

end
