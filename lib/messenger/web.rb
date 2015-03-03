require 'addressable/uri'
require 'httparty'
require 'cgi'

class Messenger::Web

  def self.valid_url?(url)
    !!Addressable::URI.parse(url)
  rescue Addressable::URI::InvalidURIError
    false
  end

  # URL format:
  #     http://example.com
  #     https://user:pass@example.com
  #
  # The body of the message is posted as the body of the request, not the query.
  def self.deliver(url, body, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    options      = options.dup
    method       = options.delete(:method) || :post
    uri          = Addressable::URI.parse(url)
    user         = CGI.unescape(uri.user) if uri.user
    password     = CGI.unescape(uri.password) if uri.password
    options      = options.merge(:basic_auth => {:username => user, :password => password}) if user || password
    uri.userinfo = nil if user || password
    response     = HTTParty.send(method, uri.to_s, options.merge(:body => body))
    Messenger::Result.new(success?(response), response)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    path = Addressable::URI.parse(url)
    if path.password
      url.sub(/#{Regexp.escape(path.password)}/, 'xxxx')
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
