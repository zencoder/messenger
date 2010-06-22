require "test_helper"

class Messenger::MessengerTest < Test::Unit::TestCase

  should "determine the proper protocol" do
    assert_equal :email, Messenger.protocol("mailto:test@example.com")
    assert_equal :email, Messenger.protocol("test@example.com")
    assert_equal :http, Messenger.protocol("http://example.com")
    assert_equal :http, Messenger.protocol("https://example.com")
    assert_equal :jabber, Messenger.protocol("jabber://test@example.com")
    assert_equal :campfire, Messenger.protocol("campfire://api_key:room_id@subdomain.campfirenow.com")
    assert_nil Messenger.protocol("bogus")
  end

  should "determine the proper notification handler given a protocol" do
    assert_equal Messenger::Email, Messenger.handler("mailto:test@example.com")
    assert_equal Messenger::Email, Messenger.handler("test@example.com")
    assert_equal Messenger::Web, Messenger.handler("http://example.com")
    assert_equal Messenger::Web, Messenger.handler("https://example.com")
    assert_equal Messenger::Jabber, Messenger.handler("jabber://test@example.com")
    assert_equal Messenger::Campfire, Messenger.handler("campfire://api_key:room_id@subdomain.campfirenow.com")
    assert_raises Messenger::ProtocolError do
      Messenger.handler("example.com")
    end
  end

  should "determine valid URLs" do
    assert Messenger.valid_url?("mailto:test@example.com")
    assert Messenger.valid_url?("test@example.com")
    assert Messenger.valid_url?("http://example.com")
    assert Messenger.valid_url?("https://example.com")
    assert Messenger.valid_url?("jabber://test@example.com")
    assert Messenger.valid_url?("campfire://api_key:room_id@subdomain.campfirenow.com")
    assert !Messenger.valid_url?("bogus")
  end

end
