module MeshChat
  module Message
    class Disconnect < Base
      def display
        location = payload['sender']['location']
        name = payload['sender']['alias']
        node = Node.find_by_location(location)
        node.update(online: false) if node
        "#{name}@#{location} has disconnected"
      end
    end
  end
end
