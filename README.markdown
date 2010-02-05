Messenger
=========

Messenger makes it easy to send messages using a variety of services (e.g. email, web, campfire, jabber). It is designed to be used via the command-line or invoked directly with in a Ruby application. One of the guiding principles behind the library is to specify as much as possible through a single URL.


Services
========

Email
-----

Email messages are send

messenger mailto:email@example.com "Message" --email-from your.email@example.com --email-subject "Hi"


Web
---

messenger http://example.com "Message"


Campfire
--------

messenger campfire://api-key:room-id@subdomain.campfirenow.com "Message"


Jabber
------

messenger jabber://email@example.com "Message" --jabber-id your.email@example.com --jabber-password #######


Config
======

Messenger will also read in ~/.messenger (a YAML file) for default config information, such as:

    jabber_id: email@example.com
    jabber_password: ########
