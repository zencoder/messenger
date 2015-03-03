require 'httparty'
require 'json'

class Messenger::Slack

  def self.valid_url?(url)
    !!matcher(url)
  rescue NoMethodError
    false
  end

  # URL format:
  #     slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room
  # Slack supports the notion of attachments, so the messages can be a little fancier. If body is a string, that
  # string will simply be sent to the room as text. `body` can also be an array of attachments, or a single attachment.
  # Attachment reference: https://api.slack.com/docs/attachments
  def self.deliver(url, body, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    display_name, base_url, key_one, key_two, secret, channel = matcher(url)
    options[:headers] ||= {}
    response = HTTParty.post(
      "https://#{base_url}/#{key_one}/#{key_two}/#{secret}",
      :headers => { "Content-Type" => "application/json"}.merge(options[:headers]),
      :body => build_message(channel, display_name, body)
    )
    Messenger::Result.new(success?(response), response)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    display_name, base_url, key_one, key_two, secret, channel = matcher(url)
    "slack://#{display_name}@#{base_url}/T********/B********/************************/#{channel}"
  end


private

  def self.build_message(channel, display_name, body)
    msg = { channel: channel, username: display_name }

    if body.is_a?(String)
      msg.merge!({ text: body })

    elsif body.is_a?(Array)
      msg['attachments'] = body

    elsif body.is_a?(Hash)
      msg['attachments'] = []
      msg['attachments'].push(body)
    end

    msg.to_json
  end

  def self.matcher(url)
    url.match(/slack:\/\/(.*)@(hooks.slack.com\/services)\/([T].*?)\/([B].*?)\/(.*)\/([#@].*)/)[1,6]
  end

  def self.success?(response)
    case response.code
    when 200, 201
      true
    else
      false
    end
  end

end
