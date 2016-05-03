#Meshchat Core [![Build Status](https://travis-ci.org/NullVoxPopuli/meshchat.svg)](https://travis-ci.org/NullVoxPopuli/meshchat) [![Code Climate](https://codeclimate.com/github/NullVoxPopuli/meshchat/badges/gpa.svg)](https://codeclimate.com/github/NullVoxPopuli/meshchat) [![Test Coverage](https://codeclimate.com/github/NullVoxPopuli/meshchat/badges/coverage.svg)](https://codeclimate.com/github/NullVoxPopuli/meshchat/coverage)

This is the core functionality for implementing a [mesh-chat](https://github.com/neuravion/mesh-chat-protocol) compatible client in ruby

[Documentation](http://nullvoxpopuli.github.io/meshchat/)

#Usage

See [Spiced Rumby](https://github.com/NullVoxPopuli/spiced_rumby) (GUI wrapper around this gem)

In order to use meshchat with your own interface, you only need to pass in your own implementation of `Display::Base`

Optionally, you may pass in a notifier to have the mesh-chat trigger notifications for your system

```ruby
Meshchat.start(
  # name of your client
  client_name: Meshchat.name,
  # version of your client
  client_version: Meshchat::VERSION,
  # your class implementing `Meshchat::Ui::Display::Base`
  display: Meshchat::Ui::Display::Base,
  # your class implementing `Meshchat::Ui::CLI::Base`
  input: Meshchat::Ui::CLI::KeyboardLineInput,
  # (optional) your class implementing `Notifier::Base`
  # typically, this hooks in to libnotify on *nix
  notifier: Meshchat::Ui::Notifier::Base,
)
```
For a lightweight, runnable sample for how to invoke this, see the included `run` script.

# Development

### Running

```bash
./run
```

### Tests

```bash
rspec
```

### Line Count

```bash
loco
```
