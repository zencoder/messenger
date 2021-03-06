# encoding: utf-8

require "test_helper"

class Messenger::WebTest < Test::Unit::TestCase

  context "Web notification" do
    setup do
      @success_response = stub("response", :code => 200)
      @failure_response = stub("response", :code => 500)
    end

    should "post a successful message" do
      stub_request(:post, "http://example.com").with(:body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).to_return(:status => 200, :body => "", :headers => {})
      result = Messenger::Web.deliver("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
      assert result.success?
      assert_equal 200, result.response.code
    end

    should "post a failed message" do
      stub_request(:post, "http://example.com").with(:body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).to_return(:status => 500, :body => "", :headers => {})
      result = Messenger::Web.deliver("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
      assert_equal false, result.success?
      assert_equal 500, result.response.code
    end

    should "raise if trying to send to an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Web.deliver("!://", "whatever")
      end
    end

    should "obfuscate the URL" do
      assert_equal "http://example.com", Messenger::Web.obfuscate("http://example.com")
      assert_equal "http://user:xxxx@example.com", Messenger::Web.obfuscate("http://user:secure_pass@example.com")
      assert_equal "https://user:xxxx@example.com", Messenger::Web.obfuscate("https://user:secure_pass@example.com")
    end

    should "raise if trying to obfuscate an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Web.obfuscate("!://")
      end
    end

    should "set username and password as options" do
      stub_request(:post, "http://user_name:secret_password@example.com").with(:body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).to_return(:status => 200, :body => "", :headers => {})
      result = Messenger::Web.deliver("http://user_name:secret_password@example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
      assert result.success?
      assert_equal 200, result.response.code
    end

    should "actually send to the correct URL when basic auth is used" do
      stub_request(:post, "http://user_name:secret_password@example.com/").with(:body => %{{ "key": "value" }}, :headers => {'Content-Type'=>'application/json'}).to_return(:status => 200, :body => "", :headers => {})
      Messenger::Web.deliver("http://user_name:secret_password@example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
    end
  end

  context "Web notificaiton URL validation" do
    should "return true for good URLs" do
      assert_equal true, Messenger::Web.valid_url?("http://example.com")
      assert_equal true, Messenger::Web.valid_url?("https://example.com")
      assert_equal true, Messenger::Web.valid_url?("https://user@example.com")
      assert_equal true, Messenger::Web.valid_url?("http://user:pass@example.com")
      assert_equal true, Messenger::Web.valid_url?("https://user:#{URI.escape('!#$%^&*¢ç⎋')}@example.com")
    end

    should "return false for bad URLs" do
      assert_equal false, Messenger::Web.valid_url?("!://")
    end
  end

end
