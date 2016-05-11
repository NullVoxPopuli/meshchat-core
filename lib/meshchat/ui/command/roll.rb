# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Roll < Command::Chat
        REGEX = /(\d+)d(\d+)(\+(\d+))?/

        def self.description
          'rolls a die in the XdY+Z format'
        end

        def initialize(input, message_dispatcher, message_factory, input_factory)
          super
          Display.debug input
          # input, X, Y, +Z, Z
          _, num, size, _, modifier = REGEX.match(input).to_a.map(&:to_i)

          result = Array.new(num) { rand(size) + 1 }.inject(:+) + modifier
          @_input = "rolls #{num}d#{size}#{modifier != 0 ? "+#{modifier}" : ''} and gets #{result}"
        end

        def show_myself(message)
          Display.emote message.display
        end

        def type
          EMOTE
        end
      end
    end
  end
end
