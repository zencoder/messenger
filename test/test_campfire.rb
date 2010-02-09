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
        result = Campfire.send("campfire://api:room@subdomain.campfirewnow.com", 'content')
        assert result.success?
        assert_equal @success_response, result.response
      end

      should "post a failed message" do
        HTTParty.expects(:post).with("http://subdomain.campfirenow.com/room/room/speak.json", :basic_auth => { :username => 'api', :password => 'x' }, :body => '{"message":{"body":"content"}}', :headers => { "Content-Type" => "application/json" }).returns(@failure_response)
        result = Campfire.send("campfire://api:room@subdomain.campfirewnow.com", 'content')
        assert_equal false, result.success?
        assert_equal @failure_response, result.response
      end

      should "raise on invalid URL" do
        assert_raises Messenger::URLError do
          Campfire.send("campfire://missing_room@subdomain.campfirewnow.com", 'content')
        end
      end
    end

  end

end
