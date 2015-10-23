module MeshChat
  module Message
    class NodeListHash < Base
      def message
        @message ||= Node.as_sha512
      end

      # node list hash is received
      # @return [NilClass] no output for this message type
      def handle
        respond
        return
      end

      def respond
        if message != Node.as_sha512
          Display.debug 'node list hashes do not match'
          location = payload['sender']['location']

          Display.debug 'sending a node list to ' + location
          node = Node.find_by_location(location)

          MeshChat::Net::Client.send(
            node: node,
            message: NodeList.new(message: Node.as_json)
          )
        else
          Display.debug 'node list hash matches'
        end
      end
    end
  end
end
