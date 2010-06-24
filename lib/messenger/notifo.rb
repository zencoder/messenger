require 'httparty'
require 'json'

class Messenger::Notifo

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
  def self.deliver(url, message, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    username = matcher(url)
    response = HTTParty.post("https://#{options[:notifo_api_username]}:#{options[:notifo_api_secret]}@api.notifo.com/v1/send_notification",
                                      :body => { :to => username, :msg => message, :title => options[:notifo_title], :uri => options[:notifo_url] })
    Messenger::Result.new(success?(response), response)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
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
