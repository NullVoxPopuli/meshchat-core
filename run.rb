require 'meshchat'

Meshchat.start(
  client_name: 'Spiced Rumby',
  display: Meshchat::Ui::Display::ReadlineDisplay, # your class implementing `Display::Base`
  input: Meshchat::Ui::CLI::ReadlineInput,
  notifier: Meshchat::Ui::Notifier::LibNotify
)
