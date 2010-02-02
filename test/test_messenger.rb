require "#{File.dirname(__FILE__)}/test_helper"

module Messenger

  class MessengerTest < Test::Unit::TestCase

    context "Protocol/Handler" do
      should "determine the proper service" do
        assert_equal :email, Messenger.protocol("mailto:test@example.com")
        assert_equal :http, Messenger.protocol("http://example.com")
        assert_equal :http, Messenger.protocol("https://example.com")
      end

      should "determine the proper notification handler given a protocol" do
        assert_equal Email, Messenger.handler("mailto:test@example.com")
        assert_equal Web, Messenger.handler("http://example.com")
        assert_equal Web, Messenger.handler("https://example.com")
      end
    end

  end

end
