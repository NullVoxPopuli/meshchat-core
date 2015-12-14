module MeshChat
  class Command
    class Online < Command::Base
      def self.description
        'shows online users'
      end

      def handle
        list = Node.online.map(&:as_info)
        msg = if list.present?
          list.join(", ")
        else
          'no one is offline'
        end

        Display.info msg
      end
    end
  end
end
