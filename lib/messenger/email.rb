require 'mail'

module Messenger

  class Email

    def self.valid_url?(url)
      !!url.match(/mailto:[^@]+@.*/)
    end

    # URL format:
    #     mailto:email@example.com
    #
    # Options:
    #     :email_from => Who the email is from
    #     :email_subject => The subject of the email
    def self.send(url, message, options={})
      raise URLError, "The URL provided is invalid" unless valid_url?(url)
      mail = Mail.new do
            from options[:email_from]
              to url.sub(/mailto:/, '')
         subject options[:email_subject]
            body message
      end
      mail.deliver!
      [true, nil]
    end

    def self.obfuscate(url)
      raise URLError, "The URL provided is invalid" unless valid_url?(url)
      url
    end

  end

end
