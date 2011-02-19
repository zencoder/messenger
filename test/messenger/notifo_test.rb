require "test_helper"

class Messenger::NotifoTest < Test::Unit::TestCase

  context "Notifo notification" do
    should "post a successful message" do
      HTTParty.expects(:post).returns(stub(:code => 200))
      result = Messenger::Notifo.deliver("notifo://testuser", 'message')
      assert result.success?
    end

    should "post a failed message" do
      HTTParty.expects(:post).returns(stub(:code => 400))
      result = Messenger::Notifo.deliver("notifo://testuser", 'message')
      assert !result.success?
    end

    should "raise when sending to an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Notifo.deliver("notifo://", 'message')
      end
    end
  end

  context "Notifo URL validation" do
    should "return true for good URLs" do
      assert_equal true, Messenger::Notifo.valid_url?("notifo://testuser")
    end

    should "return false for bad URLs" do
      assert_equal false, Messenger::Notifo.valid_url?("notifo://")
    end
  end

end
