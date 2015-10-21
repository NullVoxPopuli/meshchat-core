module MeshChat
  module Net
    module Listener
      module RequestProcessor

        module_function

        def process(raw)
          request = Request.new(raw)

          message = request.message
          update_sender_info(request.json)

          Display.present_message message
        end

        def update_sender_info(json)
          sender = json['sender']

          # if the sender isn't currently marked as active,
          # perform the server list exchange
          node = Node.find_by_uid(sender['uid'])
          unless node.online?
            node.update(online: true)
            payload = Message::NodeListHash.new
            Client.send(
              location: sender['location'],
              message: payload)
          end

          # update the node's location/alias
          # as they can change this info willy nilly
          node.update(
            location: sender['location'],
            alias_name: sender['alias']
          )
        end
      end
    end
  end
end
