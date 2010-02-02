$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'ruby-debug'
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


  def self.send(url, message, options={})
    service_handler = handler(url)
    SystemTimer.timeout_after(options[:timeout] || 15) do
      service_handler.send(url, message, options)
    end
  end


  def self.protocol(url)
    case url
    when /^mailto/: :email
    when /^http/:   :http
    end
  end

  def self.handler(url)
    case protocol(url)
    when :email: Email
    when :http:  Web
    else
      raise ProtocolError, "Malformed service URL: #{url}. Either this syntax is wrong or this service type is not yet implemented."
    end
  end


  autoload :Email, "messenger/email"
  autoload :Web, "messenger/web"

end
