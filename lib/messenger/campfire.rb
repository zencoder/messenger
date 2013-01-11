require 'httparty'
require 'json'

class Messenger::Campfire

  def self.valid_url?(url)
    !!matcher(url)
  rescue NoMethodError
    false
  end

  # URL format:
  #     campfire://api-key:room-id@subdomain.campfirenow.com
  def self.deliver(url, body, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    ssl, api_key, room, subdomain = matcher(url)
    options[:headers] ||= {}
    response = HTTParty.post(
      "http#{ssl ? "s" : ""}://#{subdomain}.campfirenow.com/room/#{room}/speak.json",
      :headers => { "Content-Type" => "application/json"}.merge(options[:headers]),
      :body => { "message" => { "body" => body } }.to_json,
      :basic_auth => {:username => api_key, :password => 'x'}
    )
    Messenger::Result.new(success?(response), response)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    ssl, api_key, room, subdomain = matcher(url)
    "campfire#{ssl ? "-ssl" : ""}://xxxx:#{room}@#{subdomain}.campfirenow.com"
  end


private

  def self.matcher(url)
    url.match(/\Acampfire(-ssl)?:\/\/([^:]+):([^@]+)@([^\.]+).campfirenow.com/)[1,4]
  end

  def self.success?(response)
    case response.code
    when 200, 201
      true
    else
      false
    end
  end

end
