require "#{File.dirname(__FILE__)}/test_helper"
require 'mail'

module Messenger

  class EmailTest < Test::Unit::TestCase

    context "Email notification" do
      setup do
        Mail.defaults do
          delivery_method :test
        end
      end

      should "send an email" do
        Email.send("mailto:to_test@example.com", "Test message", :email_from => "from_test@example.com", :email_subject => "Test")
        assert_equal 1, Mail::TestMailer.deliveries.length
        assert_equal ["to_test@example.com"], Mail::TestMailer.deliveries.first.to
        assert_equal ["from_test@example.com"], Mail::TestMailer.deliveries.first.from
        assert_equal "Test", Mail::TestMailer.deliveries.first.subject
        assert_equal "Test message", Mail::TestMailer.deliveries.first.body.to_s
      end
    end

  end

end
