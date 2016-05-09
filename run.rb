require 'meshchat'

Meshchat.start(
  name: 'Spiced Rumby',
  version: '0.10.1',
  display: Meshchat::Ui::Display::ReadlineDisplay, # your class implementing `Display::Base`
  input: Meshchat::Ui::CLI::ReadlineInput
)
