require "#{File.dirname(__FILE__)}/test_helper"
require 'httparty'

module Messenger

  class WebTest < Test::Unit::TestCase

    context "Web notification" do
      setup do
        @success_response = stub("response", :code => 200)
        @failure_response = stub("response", :code => 500)
      end

      should "post a successful message" do
        HTTParty.expects(:post).with("http://example.com", :body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).returns(@success_response)
        result = Web.send("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
        assert_equal [true, @success_response], result
      end

      should "post a failed message" do
        HTTParty.expects(:post).with("http://example.com", :body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).returns(@failure_response)
        result = Web.send("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
        assert_equal [false, @failure_response], result
      end

      should "raise if trying to send to an invalid URL" do
        assert_raises URLError do
          Web.send("http://!", :body => "whatever")
        end
      end

      should "obfuscate the URL" do
        assert_equal "http://example.com", Web.obfuscate("http://example.com")
        assert_equal "http://user:xxxx@example.com", Web.obfuscate("http://user:secure_pass@example.com")
        assert_equal "https://user:xxxx@example.com", Web.obfuscate("https://user:secure_pass@example.com")
      end

      should "raise if trying to obfuscate an invalid URL" do
        assert_raises URLError do
          Web.obfuscate("http://!")
        end
      end
    end

    context "Web notificaiton URL validation" do
      should "return true for good URLs" do
        assert true, Web.valid_url?("http://example.com")
        assert true, Web.valid_url?("https://example.com")
        assert true, Web.valid_url?("https://user@example.com")
        assert true, Web.valid_url?("http://user:pass@example.com")
        assert true, Web.valid_url?("https://user:#{URI.escape('!#$%^&*¢ç⎋')}@example.com")
      end

      should "return false for bad URLs" do
        assert_equal false, Web.valid_url?("http://!")
        assert_equal false, Web.valid_url?("http://")
        assert_equal false, Web.valid_url?("https://")
      end
    end

  end

end
