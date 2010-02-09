require 'httparty'
require 'json'

module Messenger

  class Campfire

    def self.send(url, body, options={})
      begin
        api_key, room, subdomain = url.match(/^campfire:\/\/([^:]+):([^@]+)@([^\.]+)/)[1,3]
      rescue
        raise URLError, "The URL provided is invalid"
      end
      response = HTTParty.post(
        "http://#{subdomain}.campfirenow.com/room/#{room}/speak.json",
        :basic_auth => { :username => api_key, :password => "x" },
        :headers => { "Content-Type" => "application/json" },
        :body => { "message" => { "body" => body } }.to_json
      )
      Result.new(success?(response), response)
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
