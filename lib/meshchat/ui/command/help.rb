# frozen_string_literal: true
module Meshchat
  module Ui
    module Command
      class Help < Command::Base
        def self.description
          'displays this help message'
        end

        def handle
          Meshchat::Ui::Command::COMMAND_MAP.each do |key, klass|
            if klass.respond_to?(:description)
              line = "/%-18s %s" % [key, klass.description ]
              Display.info line
            end
          end
        end
      end
    end
  end
end
