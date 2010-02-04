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
    end

  end

end
