# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Roll < Command::Chat
        REGEX = /(\d+)d(\d+)(([%\*+-\^\/])(\d+))?/

        def self.description
          'rolls a die in the XdY+Z format'
        end

        def initialize(input, message_dispatcher, message_factory, input_factory)
          super
          Display.debug input
          # input, X, Y, +Z, Z
          _, num, size, modifier, operator, number = REGEX.match(input).to_a

          result = Array.new(num.to_i) { rand(size.to_i) + 1 }.inject(:+)
          result = result.send(operator.to_sym, number.to_i) if modifier
          @_input = "rolls #{num}d#{size}#{modifier != 0 ? modifier : ''} and gets #{result}"
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
