module Messenger

  class MessengerError < StandardError; end

  class ProtocolError < MessengerError; end
  class NotificationTimeout < MessengerError; end

end
