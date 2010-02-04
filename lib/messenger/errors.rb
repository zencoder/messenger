module Messenger

  class MessengerError < StandardError; end
  class ProtocolError < MessengerError; end
  class URLError < MessengerError; end

end
