require "test_helper"

class Messenger::SlackTest < Test::Unit::TestCase

  context "Slack notification" do
    setup do
      @success_response = stub(:code => 200)
      @failure_response = stub(:code => 500)
    end

    should "post a successful message as a string" do
      HTTParty.expects(:post).with("https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", :body => { channel: '#room', username: 'displayname', text: 'hello world!' }.to_json, :headers => { "Content-Type" => "application/json"}).returns(@success_response)
      result = Messenger::Slack.deliver("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room", 'hello world!')
      assert result.success?
      assert_equal @success_response, result.response
    end

    should "post a successful message as an object" do
      HTTParty.expects(:post).with("https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", :body => { channel: '#room', username: 'displayname', attachments: [{ fallback: 'hello world!', color: 'good' }] }.to_json, :headers => { "Content-Type" => "application/json"}).returns(@success_response)
      result = Messenger::Slack.deliver("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room", { fallback: 'hello world!', color: 'good' })
      assert result.success?
      assert_equal @success_response, result.response
    end

    should "post a successful message as an array" do
      HTTParty.expects(:post).with("https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", :body => { channel: '#room', username: 'displayname', attachments: [{ fallback: 'hello world!', color: 'good' }, { fallback: 'meh', color: 'warning' }] }.to_json, :headers => { "Content-Type" => "application/json"}).returns(@success_response)
      result = Messenger::Slack.deliver("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room", [{ fallback: 'hello world!', color: 'good' }, { fallback: 'meh', color: 'warning' }])
      assert result.success?
      assert_equal @success_response, result.response
    end

    should "post a successful message with a custom emoji" do
      HTTParty.expects(:post).with("https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", :body => { channel: '#room', username: 'displayname', icon_emoji: ':ghost:', text: 'hello world!' }.to_json, :headers => { "Content-Type" => "application/json"}).returns(@success_response)
      result = Messenger::Slack.deliver("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room", 'hello world!', { icon_emoji: ':ghost:' })
      assert result.success?
      assert_equal @success_response, result.response
    end

    should "post a successful message with a custom avatar url" do
      HTTParty.expects(:post).with("https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", :body => { channel: '#room', username: 'displayname', icon_url: 'http://example.com/avatar.png', text: 'hello world!' }.to_json, :headers => { "Content-Type" => "application/json"}).returns(@success_response)
      result = Messenger::Slack.deliver("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room", 'hello world!', { icon_url: 'http://example.com/avatar.png' })
      assert result.success?
      assert_equal @success_response, result.response
    end

    should "post a failed message" do
      HTTParty.expects(:post).with("https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX", :body => { channel: '#room', username: 'displayname', text: 'hello world!' }.to_json, :headers => { "Content-Type" => "application/json"}).returns(@failure_response)
      result = Messenger::Slack.deliver("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room", 'hello world!')
      assert_equal false, result.success?
      assert_equal @failure_response, result.response
    end

    should "raise when sending to an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Slack.deliver("slack://hooks.slack.com/blah/blah", 'content')
      end
    end

    should "obfuscate the URL" do
      assert_equal "slack://displayname@hooks.slack.com/services/T********/B********/************************/#room", Messenger::Slack.obfuscate("slack://displayname@hooks.slack.com/services/T1234567/B12334567/asdfasdfasdfasdfasdf/#room")
    end

    should "raise when obfuscating an invalid URL" do
      assert_raises Messenger::URLError do
        Messenger::Slack.obfuscate("slack://hooks.slack.com/blah/blah")
      end
    end
  end

  context "Slack URL validation" do
    should "return true for good URLs" do
      assert_equal true, Messenger::Slack.valid_url?("slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room")
    end

    should "return false for bad URLs" do
      assert_equal false, Messenger::Campfire.valid_url?("slack://!")
      assert_equal false, Messenger::Campfire.valid_url?("slack://user@hooks.slack.com")
      assert_equal false, Messenger::Campfire.valid_url?("slack://hooks.slack.com")
      assert_equal false, Messenger::Campfire.valid_url?("slack://user@hooks.slack.com/asdfasdf/asdfasdf/asdfasdf")
      assert_equal false, Messenger::Campfire.valid_url?("slack://user@hooks.slack.com/asdfasdf")
    end
  end
end
