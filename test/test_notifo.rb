require "test_helper"
require 'httparty'

module Messenger

  class NotifoTest < Test::Unit::TestCase

    context "Notifo notification" do
      should "post a successful message" do
        stub_request(:post, "https://api.notifo.com/v1/send_notification").to_return(:status => 200)
        result = Notifo.send("notifo://testuser", 'message')
        assert result.success?
      end

      should "post a failed message" do
        stub_request(:post, "https://api.notifo.com/v1/send_notification").to_return(:status => 400)
        result = Notifo.send("notifo://testuser", 'message')
        assert !result.success?
      end

      should "raise when sending to an invalid URL" do
        assert_raises URLError do
          Notifo.send("notifo://", 'message')
        end
      end
    end

    context "Notifo URL validation" do
      should "return true for good URLs" do
        assert true, Notifo.valid_url?("notifo://testuser")
      end

      should "return false for bad URLs" do
        assert_equal false, Notifo.valid_url?("notifo://")
      end
    end

  end

end
