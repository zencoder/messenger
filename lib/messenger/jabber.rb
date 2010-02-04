require 'xmpp4r-simple'

module Messenger

  class Jabber

    def self.send(url, body, options={})
      recipient, host = url.sub("jabber://", "").split("/")[0,2]
      jabber = ::Jabber::Simple.new(options[:jabber_id], options[:jabber_password], host)
      jabber.deliver(recipient, body)
      pending_messages_count = 1
      until pending_messages_count == 0
        pending_messages_count = jabber.send(:queue, :pending_messages).size
        sleep 1
      end
    end

  end

end


# MONKEY PATCHING
#
# xmpp4r-simple does not allow you to specify the jabber host, but we need to do that for Google Apps.

module Jabber

  class Simple

    def initialize(jid, password, host=nil, status=nil, status_message="Available")
      @jid = jid
      @password = password
      @host = host
      @disconnected = false
      status(status, status_message)
      start_deferred_delivery_thread
    end

    def connect!
      raise ConnectionError, "Connections are disabled - use Jabber::Simple::force_connect() to reconnect." if @disconnected
      # Pre-connect
      @connect_mutex ||= Mutex.new

      # don't try to connect if another thread is already connecting.
      return if @connect_mutex.locked?

      @connect_mutex.lock
      disconnect!(false) if connected?

      # Connect
      jid = JID.new(@jid)
      my_client = Client.new(@jid)
      my_client.connect(@host)
      my_client.auth(@password)
      self.client = my_client

      # Post-connect
      register_default_callbacks
      status(@presence, @status_message)
      @connect_mutex.unlock
    end

  end

end
