require 'httparty'
require 'json'

module Messenger

  class Campfire

    def self.valid_url?(url)
      !!matcher(url)
    rescue NoMethodError
      false
    end

    # URL format:
    #     campfire://api-key:room-id@subdomain.campfirenow.com
    def self.send(url, body, options={})
      raise URLError, "The URL provided is invalid" unless valid_url?(url)
      api_key, room, subdomain = matcher(url)
      response = HTTParty.post(
        "http://#{subdomain}.campfirenow.com/room/#{room}/speak.json",
        :basic_auth => { :username => api_key, :password => "x" },
        :headers => { "Content-Type" => "application/json" },
        :body => { "message" => { "body" => body } }.to_json
      )
      Result.new(success?(response), response)
    end

    def self.obfuscate(url)
      raise URLError, "The URL provided is invalid" unless valid_url?(url)
      api_key, room, subdomain = matcher(url)
      "campfire://xxxx:#{room}@#{subdomain}.campfirenow.com"
    end


  private

    def self.matcher(url)
      url.match(/^campfire:\/\/([^:]+):([^@]+)@([^\.]+).campfirenow.com/)[1,3]
    end

    def self.success?(response)
      case response.code
      when 200, 201: true
      else
        false
      end
    end

  end

end
