require "test_helper"

class Messenger::EmailTest < Test::Unit::TestCase

  context "Email notification" do
    setup do
      Mail.defaults do
        delivery_method :test
      end
    end

    should "send an email" do
      Messenger::Email.deliver("mailto:to_test@example.com", "Test message", :email_from => "from_test@example.com", :email_subject => "Test")
      assert_equal 1, Mail::TestMailer.deliveries.length
      assert_equal ["to_test@example.com"], Mail::TestMailer.deliveries.first.to
      assert_equal ["from_test@example.com"], Mail::TestMailer.deliveries.first.from
      assert_equal "Test", Mail::TestMailer.deliveries.first.subject
      assert_equal "Test message", Mail::TestMailer.deliveries.first.body.to_s
    end

    should "raise if trying to send to an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Email.deliver("mailto:test", :body => "whatever", :email_from => "from_test@example.com", :email_subject => "Test")
      end
    end

    should "obfuscate the URL" do
      assert_equal "mailto:test@example.com", Messenger::Email.obfuscate("mailto:test@example.com")
    end

    should "raise if trying obfuscate an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Email.obfuscate("mailto:test")
      end
    end
  end

  context "Email notificaiton URL validation" do
    should "return true for good URLs" do
      assert true, Messenger::Email.valid_url?("mailto:test@example.com")
    end

    should "return false for bad URLs" do
      assert_equal false, Messenger::Email.valid_url?("mailto:")
      assert_equal false, Messenger::Email.valid_url?("mailto:test")
      assert_equal false, Messenger::Email.valid_url?("mailto:example.com")
    end
  end

end
