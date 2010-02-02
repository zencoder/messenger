require "#{File.dirname(__FILE__)}/test_helper"
require 'httparty'

module Messenger

  class WebTest < Test::Unit::TestCase

    context "Web notification" do
      should "post a message" do
        HTTParty.expects(:post).with("http://example.com", :body => '{ "key": "value" }', :content_type => "application/json", :accept => "application/json")
        Web.send("http://example.com", '{ "key": "value" }', :content_type => "application/json", :accept => "application/json")
      end
    end

  end

end
