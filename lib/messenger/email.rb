require 'pony'

module Messenger

  class Email

    def self.send(url, message, options={})
      Pony.mail(
        :to => url.sub(/mailto:/, ''),
        :from => options[:from],
        :subject => options[:subject],
        :body => message
      )
    end

  end

end
