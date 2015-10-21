module MeshChat
  class Instance
    attr_accessor :client_name, :client_version, :display

    class << self
      delegate :client_name, :client_version, :display,
        to: :instance

      def start(options)
        # calling instance to get things going
        @instance = new(options)
        @instance.start_ui(options[:display], options[:on_display_start])
      end

      def instance
        @instance
      end
    end

    def initialize(options = {})
      self.client_name = options[:client_name] || MeshChat::NAME
      self.client_version = options[:client_version] || MeshChat::VERSION
    end

    # @param [class] klass should be something that implements Display::Base
    # @param [Proc] proc what to do when starting the UI
    def start_ui(klass, on_display_start)
      self.display = Display::Manager.new(klass)
      display.start do
        on_display_start.call if on_display_start
      end
    end
  end
end
