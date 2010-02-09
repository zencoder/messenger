require "#{File.dirname(__FILE__)}/test_helper"
require 'xmpp4r-simple'

module Messenger

  class JabberTest < Test::Unit::TestCase

    context "Jabber notification" do
      setup do
        @successful_jabber = stub("jabber", :deliver => nil, :queue => stub("queue", :size => 0), :subscribed_to? => true)
        @failed_jabber = stub("jabber", :deliver => nil, :queue => stub("queue", :size => 0), :subscribed_to? => false)
      end

      should "send a successful jabber message" do
        ::Jabber::Simple.expects(:new).with("notifier@zencoder.com", "asdfasdf", nil).returns(@successful_jabber)
        result = Jabber.send("jabber://brandon@zencoder.com", "Test message", :jabber_id => "notifier@zencoder.com", :jabber_password => "asdfasdf")
        assert result.success?
        assert_nil result.response
      end

      should "determine and set the jabber host" do
        ::Jabber::Simple.expects(:new).with("notifier@zencoder.com", "asdfasdf", "host.com").returns(@successful_jabber)
        result = Jabber.send("jabber://brandon@zencoder.com/host.com", "Test message", :jabber_id => "notifier@zencoder.com", :jabber_password => "asdfasdf")
        assert result.success?
        assert_nil result.response
      end

      should "fail if the recipient is not subscribed" do
        ::Jabber::Simple.expects(:new).with("notifier@zencoder.com", "asdfasdf", nil).returns(@failed_jabber)
        result = Jabber.send("jabber://brandon@zencoder.com", "Test message", :jabber_id => "notifier@zencoder.com", :jabber_password => "asdfasdf")
        assert_equal false, result.success?
        assert_equal "Not yet authorized", result.response
      end
    end

  end

end
