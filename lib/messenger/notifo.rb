require 'httparty'
require 'json'

module Messenger

  class Notifo

    def self.valid_url?(url)
      !!url.match(/^notifo:\/\/.+$/)
    end

    # URL format:
    #     notifo://username
    #
    # Options:
    #     :notifo_api_username => The service's API username
    #     :notifo_api_secret => The service's API secret
    #     :notifo_title => The notificaiton title
    #     :notifo_url => Open this URL
    def self.send(url, message, options={})
      raise URLError, "The URL provided is invalid" unless valid_url?(url)
      username = matcher(url)
      response = HTTParty.post("https://api.notifo.com/v1/send_notification",
                   :body => { :to => username, :msg => message, :title => options[:notifo_title], :uri => options[:notifo_url] },
                   :basic_auth => { :username => options[:notifo_api_username], :password => options[:notifo_api_secret] })
      Result.new(success?(response), response)
    end

    def self.obfuscate(url)
      raise URLError, "The URL provided is invalid" unless valid_url?(url)
      url
    end


  private

    def self.matcher(url)
      url.match(/^notifo:\/\/(.+)/)[1]
    end

    def self.success?(response)
      response.code == 200
    end

  end

end
