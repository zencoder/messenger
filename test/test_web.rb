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
        assert result.success?
        assert_equal @success_response, result.response
      end

      should "post a failed message" do
        HTTParty.expects(:post).with("http://example.com", :body => '{ "key": "value" }', :headers => { "Content-Type" => "application/json" }).returns(@failure_response)
        result = Web.send("http://example.com", '{ "key": "value" }', :headers => { "Content-Type" => "application/json" })
        assert_equal false, result.success?
        assert_equal @failure_response, result.response
      end
    end

  end

end
