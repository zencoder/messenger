require "#{File.dirname(__FILE__)}/test_helper"

module Messenger

  class MessengerTest < Test::Unit::TestCase

    should "determine the proper protocol" do
      assert_equal :email, Messenger.protocol("mailto:test@example.com")
      assert_equal :http, Messenger.protocol("http://example.com")
      assert_equal :http, Messenger.protocol("https://example.com")
      assert_equal :jabber, Messenger.protocol("jabber://test@example.com")
      assert_equal :campfire, Messenger.protocol("campfire://api_key:room_id@subdomain.campfirenow.com")
    end

    should "determine the proper notification handler given a protocol" do
      assert_equal Email, Messenger.handler("mailto:test@example.com")
      assert_equal Web, Messenger.handler("http://example.com")
      assert_equal Web, Messenger.handler("https://example.com")
      assert_equal Jabber, Messenger.handler("jabber://test@example.com")
      assert_equal Campfire, Messenger.handler("campfire://api_key:room_id@subdomain.campfirenow.com")
    end

  end

end
