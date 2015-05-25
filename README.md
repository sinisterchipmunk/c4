# Principles

Compact, lightweight, out-of-your way. No unnecessary magic. No stupid digest
loops or $apply crap. No stupid wrappers around core JS functions like
setTimeout.

Prefer small, testable services over monolithic controllers.

DI is the devil, don't use it. Hard dependencies like on jQuery should be
managed internally by the module that consumes them. Soft dependencies like
a module relying on another module should not be managed at all, and
communicate entirely over the message bus.

# Strong Opinions

- CoffeeScript. "Pure" JavaScript could be used, but I'm not going to support
  it. CS is a good way to write code, people should use it. Therefore I don't
  care if the JS counterpart is pretty or easy to write. If the CS looks good
  then that's enough.

- PostalJS. People probably could write code to not use message buses in most
  cases, but they should use messages, and C4 will expect them to do so.

# Architecture

Rely on postal.js for messaging. Views are compiled JST. Objects are received
over the bus and passed to JST by the framework. Prefer messaging over any
tight coupling of modules.

Encourage modular design, coordination between modules via message bus.

Encourage but don't force resourceful routes.

App boot-up process:
  - pre-boot callbacks, useful?
  - instantiate each module / register core subscriptions / register
    per-module routes
  - invoke matching route, app is started

Decouple to the extreme. Prefer message bus wherever possible. Test services
via message bus, test views via message bus.

DVS - Data, View, Service. Not MVC.

Difference:
  - C4 has no models or controllers: only services, views and data. Services
    manipulate data, retrieve data, publish data to the bus.
  - Controller is traditionally used to tie view to model. Services could be
    like controllers, but they don't have a direct reference to views at all.
    Since models don't exist, if a service is a controller (it isn't), then it
    is a fat controller, while in MVC controllers are normally skinny and
    business logic would go into models.

# Examples

