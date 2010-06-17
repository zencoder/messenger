$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'messenger/errors'
require 'system_timer'


module Messenger

  MESSAGER_VERSION = [0,1] unless defined?(MESSAGER_VERSION)
  APP_ROOT = File.expand_path(File.dirname(__FILE__) + '/..') unless defined?(APP_ROOT)

  def self.version
    MESSAGER_VERSION.join(".")
  end

  def self.root
    APP_ROOT
  end


  def self.valid_url?(url)
    service_handler = handler(url)
    service_handler.valid_url?(url)
  rescue ProtocolError
    false
  end

  def self.send(url, message, options={})
    service_handler = handler(url)
    SystemTimer.timeout_after(options[:timeout] || 15) do
      service_handler.send(url, message, options)
    end
  end

  def self.obfuscate(url)
    service_handler = handler(url)
    service_handler.obfuscate(url)
  end


  def self.protocol(url)
    # TODO: More services
    #   sms://1231231234
    #   twitter://username
    #   aim://username
    case url
    when /^http/:     :http
    when /^campfire/: :campfire
    when /^jabber/:   :jabber
    when /^mailto|@+/:   :email
    end
  end

  def self.handler(url)
    case protocol(url)
    when :email:    Email
    when :http:     Web
    when :campfire: Campfire
    when :jabber:   Jabber
    else
      raise ProtocolError, "Malformed service URL: #{url}. Either this syntax is wrong or this service type is not yet implemented."
    end
  end


  autoload :Result, "messenger/result"
  autoload :Email, "messenger/email"
  autoload :Web, "messenger/web"
  autoload :Campfire, "messenger/campfire"
  autoload :Jabber, "messenger/jabber"

end
