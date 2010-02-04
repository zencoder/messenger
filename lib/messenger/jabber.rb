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
