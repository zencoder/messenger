require 'httparty'
require 'json'

class Messenger::Slack

  def self.valid_url?(url)
    !!matcher(url)
  end

  # URL format:
  #     slack://displayname@hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX/#room
  # Slack supports the notion of attachments, so the messages can be a little fancier. If body is a string, that
  # string will simply be sent to the room as text. `body` can also be an array of attachments, or a single attachment.
  # Attachment reference: https://api.slack.com/docs/attachments
  def self.deliver(url, body, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    parsed_url = matcher(url)

    options[:headers] ||= {}
    response = HTTParty.post(
      "https://#{parsed_url[:base_url]}/#{parsed_url[:key_one]}/#{parsed_url[:key_two]}/#{parsed_url[:secret]}",
      :headers => { "Content-Type" => "application/json"}.merge(options[:headers]),
      :body => build_message(parsed_url[:channel], parsed_url[:display_name], body, options)
    )
    Messenger::Result.new(success?(response), response)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    parsed_url = matcher(url)
    "slack://#{parsed_url[:display_name]}@#{parsed_url[:base_url]}/T********/B********/************************/#{parsed_url[:channel]}"
  end


private

  def self.build_message(channel, display_name, body, options)
    msg = { channel: channel, username: display_name }

    msg['icon_emoji'] = options['icon_emoji'] if options['icon_emoji']
    msg['icon_url'] = options['icon_url'] if options['icon_url']

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
    return false unless match = url.match(/slack:\/\/(.*)@(hooks.slack.com\/services)\/([T].*?)\/([B].*?)\/(.*)\/([#@].*)/)

    {
      display_name: match[1],
      base_url: match[2],
      key_one: match[3],
      key_two: match[4],
      secret: match[5],
      channel: match[6]
    }
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
