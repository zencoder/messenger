require "test_helper"
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

      should "raise when sending to an invalid URL" do
        assert_raises URLError do
          Jabber.send("jabber://", :jabber_id => "asdf", :jabber_password => "asdf")
        end
      end

      should "obfuscate the URL" do
        assert_equal "jabber://test@example.com", Jabber.obfuscate("jabber://test@example.com")
      end

      should "raise when obfuscating an invalid URL" do
        assert_raises URLError do
          Jabber.obfuscate("jabber://")
        end
      end
    end

    context "Jabber URL validation" do
      should "return true for good URLs" do
        assert true, Jabber.valid_url?("jabber://test@example.com")
      end

      should "return false for bad URLs" do
        assert_equal false, Jabber.valid_url?("jabber://!")
        assert_equal false, Jabber.valid_url?("jabber://test")
        assert_equal false, Jabber.valid_url?("jabber://example.com")
      end
    end

  end

end
