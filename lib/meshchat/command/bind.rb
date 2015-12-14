require 'socket'
require 'open-uri'

module MeshChat
  class Command
    class Bind < Command::Base
      def self.description
        'helper for choosing what ip address to use for yourself'
      end

      def handle
        options = ip_addresses
        option_numbers = []
        Display.success 'Choose an ip:'
        options.each_with_index do |ip, index|
          Display.info "#{index}: #{ip}"
          option_numbers << index
        end

        selected = MeshChat::CLI.get_input

        if option_numbers.include?(selected.to_i)
          Display.success Settings.set('ip', with: options[selected.to_i])
        else
          Display.alert 'Invalid selection'
          handle # repeat
        end


      end

      def ip_addresses
        local =  Socket.getifaddrs.map { |i| i.addr.ip_address if i.addr.ipv4? }.compact
        # get public
        remote_ip = open('http://whatismyip.akamai.com').read
        local << remote_ip
        local
      end
    end
  end
end
