require 'mail'

class Messenger::Email

  def self.valid_url?(url)
    !!url.match(/\A(mailto:)?[^@]+@.*\Z/)
  end

  # URL format:
  #     mailto:email@example.com
  #
  # Options:
  #     :email_from => Who the email is from
  #     :email_subject => The subject of the email
  def self.deliver(url, message, options={})
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    mail = Mail.new do
          from options[:email_from]
            to url.sub(/\Amailto:/, '')
       subject options[:email_subject]
          body message
    end
    mail.deliver!
    Messenger::Result.new(true, nil)
  rescue Errno::ECONNREFUSED, Errno::EAFNOSUPPORT => e
    Messenger::Result.new(false, e)
  end

  def self.obfuscate(url)
    raise Messenger::URLError, "The URL provided is invalid" unless valid_url?(url)
    url
  end

end
