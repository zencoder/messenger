require "#{File.dirname(__FILE__)}/test_helper"
require 'httparty'

module Messenger

  class CampfireTest < Test::Unit::TestCase

    context "Campfire notification" do
      setup do
        @success_response = stub("response", :code => 200)
        @failure_response = stub("response", :code => 500)
      end

      should "post a successful message" do
        HTTParty.expects(:post).with("http://subdomain.campfirenow.com/room/room/speak.json", :basic_auth => { :username => 'api', :password => 'x' }, :body => '{"message":{"body":"content"}}', :headers => { "Content-Type" => "application/json" }).returns(@success_response)
        result = Campfire.send("campfire://api:room@subdomain.campfirenow.com", 'content')
        assert result.success?
        assert_equal @success_response, result.response
      end

      should "post a failed message" do
        HTTParty.expects(:post).with("http://subdomain.campfirenow.com/room/room/speak.json", :basic_auth => { :username => 'api', :password => 'x' }, :body => '{"message":{"body":"content"}}', :headers => { "Content-Type" => "application/json" }).returns(@failure_response)
        result = Campfire.send("campfire://api:room@subdomain.campfirenow.com", 'content')
        assert_equal false, result.success?
        assert_equal @failure_response, result.response
      end

      should "raise when sending to an invalid URL" do
        assert_raises URLError do
          Campfire.send("campfire://missing_room@subdomain.campfirenow.com", 'content')
        end
      end

      should "obfuscate the URL" do
        assert_equal "campfire://xxxx:1234@example.campfirenow.com", Campfire.obfuscate("campfire://asdf1234:1234@example.campfirenow.com")
      end

      should "raise when obfuscating an invalid URL" do
        assert_raises URLError do
          Campfire.obfuscate("campfire://missing_room@subdomain.campfirenow.com")
        end
      end
    end

    context "Campfire URL validation" do
      should "return true for good URLs" do
        assert true, Campfire.valid_url?("campfire://api_key:room@subdomain.campfirenow.com")
      end

      should "return false for bad URLs" do
        assert_equal false, Campfire.valid_url?("campfire://!")
        assert_equal false, Campfire.valid_url?("campfire://api_key@subdomain.campfirenow.com")
        assert_equal false, Campfire.valid_url?("campfire://:room@subdomain.campfirenow.com")
        assert_equal false, Campfire.valid_url?("campfire://api_key:room@subdomain")
        assert_equal false, Campfire.valid_url?("campfire://api_key:room@campfirenow.com")
      end
    end

  end

end
