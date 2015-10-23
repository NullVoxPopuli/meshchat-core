module MeshChat
  module Message
    class NodeList < Base
      def message
        @message ||= Node.as_json
      end

      def handle
        respond
        return
      end

      # only need to respond if this server has node entries that the
      # sender of this message doesn't have
      def respond
        received_list = message
        we_only_have, they_only_have = Node.diff(received_list)

        if they_only_have.present?
          they_only_have.each do |n|
            # be sure that we don't add ourselves
            unless n['uid'] == Settings['uid']
              Node.from_json(n).save!
            end
          end
        end


        location = payload['sender']['location']

        node = Node.find_by_location(location)
        if we_only_have.present?

          # give the sender our list
          MeshChat::Net::Client.send(
            node: node,
            message: NodeListDiff.new(message: we_only_have)
          )

          # give people we know about
          # (but the sender of the Node List may not know about)
          # our node list diff
          Node.online.each do |entry|
            MeshChat::Net::Client.send(
              node: entry,
              message: NodeListDiff.new(message: they_only_have)
            )
          end
        else
          # lists are in sync, confirm with hash
          MeshChat::Net::Client.send(
            node: node,
            message: NodeListHash.new
          )
        end

      end
    end
  end
end
