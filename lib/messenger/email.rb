require 'mail'

module Messenger

  class Email

    # URL format:
    #     mailto:email@example.com
    #
    # Options:
    #     :email_from => Who the email is from
    #     :email_subject => The subject of the email
    def self.send(url, message, options={})
      mail = Mail.new do
            from options[:email_from]
              to url.sub(/mailto:/, '')
         subject options[:email_subject]
            body message
      end
      mail.delivery_method :sendmail
      mail.deliver!
      [true, nil]
    end

  end

end
