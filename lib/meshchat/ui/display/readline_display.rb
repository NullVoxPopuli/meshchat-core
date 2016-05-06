# frozen_string_literal: true
module Meshchat
  module Ui
    module Display
      class ReadlineDisplay < Meshchat::Ui::Display::Base
        def start
          puts "\n"
          alert 'Welcome to Spiced Rumby!'
          puts "\n"
          puts "\n"
          # Start up Ripl, but it will not receive any user input
          # Ripl.start
        end

        def print_non_destructively(text)
          # Example of writing output while line is being edited.
          #
          # See also http://stackoverflow.com/questions/1512028/gnu-readline-how-do-clear-the-input-line
          if buffer = Readline.line_buffer
            print "\b \b" * buffer.size
            print "\r"
          end

          begin
            puts text + "\n"
          ensure
            Readline.forced_update_display
          end
        end

        # TODO: find a more elegant way to handle color
        def add_line(line)
          print_non_destructively(line)
        end

        def info(msg)
          if msg.is_a?(Hash)
            message_parts_for(msg) do |time, name, message|
              colored_time = (time.to_s + ' ').colorize(:magenta)
              colored_name = (name + ' ').colorize(:light_black)
              colored_message = message.colorize(:light_black)

              print_non_destructively(colored_time + colored_name + colored_message)
            end
          else
            print_non_destructively(msg.colorize(:light_black))
          end
        end

        def warning(msg)
          print_non_destructively(msg.colorize(:yellow))
        end

        def alert(msg)
          print_non_destructively(msg.colorize(:red))
        end

        def success(msg)
          print_non_destructively(msg.colorize(:green))
        end

        def emote(msg)
          message_parts_for(msg) do |time, name, message|
            colored_time = (time.to_s + ' ').colorize(:magenta)
            colored_name = (name + ' ').colorize(:light_black)
            colored_message = message.colorize(:light_black)

            print_non_destructively(colored_time + colored_name + colored_message)
          end
        end

        def chat(msg)
          message_parts_for(msg) do |time, name, message|
            colored_time = (time.to_s + ' ').colorize(:light_magenta)
            colored_name = (name + ' ').colorize(:cyan)

            print_non_destructively(colored_time + colored_name + message)
          end
        end

        def whisper(msg)
          message_parts_for(msg) do |time, name, message|
            colored_time = (time.to_s + ' ').colorize(:magenta).bold
            colored_name = (name + ' ').colorize(:light_black).bold
            colored_message = message.colorize(:blue).bold

            print_non_destructively(colored_time + colored_name + colored_message)
          end
        end

        def message_parts_for(msg)
          return yield(nil, nil, msg) if msg.is_a?(String)

          time = msg[:time].strftime('%H:%M:%S')
          name = msg[:from].to_s
          message = msg[:message]

          yield(time, name, message)
        end
      end
    end
  end
end
