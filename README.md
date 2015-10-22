#MeshChat (Ruby) [![Build Status](https://travis-ci.org/NullVoxPopuli/meshchat.svg)](https://travis-ci.org/NullVoxPopuli/meshchat) [![Code Climate](https://codeclimate.com/github/NullVoxPopuli/meshchat/badges/gpa.svg)](https://codeclimate.com/github/NullVoxPopuli/meshchat) [![Test Coverage](https://codeclimate.com/github/NullVoxPopuli/meshchat/badges/coverage.svg)](https://codeclimate.com/github/NullVoxPopuli/meshchat/coverage)

This is the core functionality for implementing a [mesh-chat](https://github.com/neuravion/mesh-chat) compatible client in ruby

#Usage

See [Spiced Gracken](https://github.com/NullVoxPopuli/spiced_gracken)

In order to use meshchat with your own interface, you only need to pass in your own implementations of `Display::Base` and `CLI::Base`

```ruby
MeshChat.start(
  client_name: NAME, # name of your client
  client_version: VERSION, # version of your client
  display: ui, # your class of your implementation of `Display::Base`
  input: input, # your class of your implementation of `CLI::Base`
  on_display_start: ->{ MeshChat::CLI.check_startup_settings } # optional
)
```
