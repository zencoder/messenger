require "#{File.dirname(__FILE__)}/test_helper"
require 'pony'

module Messenger

  class EmailTest < Test::Unit::TestCase

    context "Email notification" do
      should "send an email" do
        Pony.expects(:mail).with(:to => "test@example.com", :body =>  "Test message", :from => "test@example.com", :subject => "Test")
        Email.send("mailto:test@example.com", "Test message", :from => "test@example.com", :subject => "Test")
      end
    end

  end

end
