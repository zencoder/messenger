require 'pony'

module Messenger

  class Email

    # URL format:
    #     mailto:email@example.com
    #
    # Options:
    #     :email_from => Who the email is from
    #     :email_subject => The subject of the email
    def self.send(url, message, options={})
      Pony.mail(
        :to => url.sub(/mailto:/, ''),
        :from => options[:email_from],
        :subject => options[:email_subject],
        :body => message
      )
      [true, nil]
    end

  end

end
