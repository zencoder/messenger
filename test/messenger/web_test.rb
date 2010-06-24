require "test_helper"

class Messenger::WebTest < Test::Unit::TestCase

  context "Web notification" do
    setup do
      @success_response = stub("response", :code => 200)
      @failure_response = stub("response", :code => 500)
    end

    should "post a successful message" do
      HTTParty.expects(:post).with("http://example.com", :body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).returns(@success_response)
      result = Messenger::Web.deliver("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
      assert result.success?
      assert_equal @success_response, result.response
    end

    should "post a failed message" do
      HTTParty.expects(:post).with("http://example.com", :body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).returns(@failure_response)
      result = Messenger::Web.deliver("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
      assert_equal false, result.success?
      assert_equal @failure_response, result.response
    end

    should "raise if trying to send to an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Web.deliver("http://!", "whatever")
      end
    end

    should "obfuscate the URL" do
      assert_equal "http://example.com", Messenger::Web.obfuscate("http://example.com")
      assert_equal "http://user:xxxx@example.com", Messenger::Web.obfuscate("http://user:secure_pass@example.com")
      assert_equal "https://user:xxxx@example.com", Messenger::Web.obfuscate("https://user:secure_pass@example.com")
    end

    should "raise if trying to obfuscate an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Web.obfuscate("http://!")
      end
    end
  end

  context "Web notificaiton URL validation" do
    should "return true for good URLs" do
      assert true, Messenger::Web.valid_url?("http://example.com")
      assert true, Messenger::Web.valid_url?("https://example.com")
      assert true, Messenger::Web.valid_url?("https://user@example.com")
      assert true, Messenger::Web.valid_url?("http://user:pass@example.com")
      assert true, Messenger::Web.valid_url?("https://user:#{URI.escape('!#$%^&*¢ç⎋')}@example.com")
    end

    should "return false for bad URLs" do
      assert_equal false, Messenger::Web.valid_url?("http://!")
      assert_equal false, Messenger::Web.valid_url?("http://")
      assert_equal false, Messenger::Web.valid_url?("https://")
    end
  end

end
