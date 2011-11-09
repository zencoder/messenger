require 'httparty'

class Messenger::Web

  def self.valid_url?(url)
    !!URI.parse(url)
  rescue URI::InvalidURIError
    false
  end

  # URL format:
  #     http://example.com
  #     https://user:pass@example.com
  #
  # The body of the message is posted as the body of the request, not the query.
  def self.deliver(url, body, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    method = options.delete(:method) || :post
    response = HTTParty.send(method, url, options.merge(:body => body, :basic_auth => {:username => URI.parse(url).user, :password => URI.parse(url).password}))
    Messenger::Result.new(success?(response), response)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    path = URI.parse(url)
    if path.password
      url.sub(/#{path.password}/, 'xxxx')
    else
      url
    end
  end


private

  def self.success?(response)
    case response.code
    when 200..299
      true
    else
      false
    end
  end

end
