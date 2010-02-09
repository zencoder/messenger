Messenger
=========

Messenger makes it easy to send messages using a variety of services (e.g. email, web, campfire, jabber). It is designed to be used via the command-line or invoked directly with in a Ruby application. One of the guiding principles behind the library is to specify as much as possible through a single URL.


Services
========

Email
-----

Email messages are sent using the Pony gem.

    messenger mailto:email@example.com "Message" --email-from your.email@example.com --email-subject "Hi"


Web
---

Web posts are send using the HTTParty gem. The message is sent as the request body, not the query.

    messenger http://example.com "Message"


Campfire
--------

Campfire messages are sent using the HTTParty gem against the Campfire API.

    messenger campfire://api-key:room-id@subdomain.campfirenow.com "Message"


Jabber
------

Jabber messages are sent using the xmppr4-simple gem. It's important to note that the jabber server can be sent in the URL if it can't be inferred from the jabber ID (as is the case for Google Apps ids).

    messenger jabber://email@example.com/jabber_server "Message" --jabber-id your.email@example.com --jabber-password #######


Config
======

Messenger will also read in ~/.messenger (a YAML file) for default config information, such as:

    jabber_id: email@example.com
    jabber_password: ########


(c) 2010 Brandon Arbini / Zencoder, Inc.
