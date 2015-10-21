module MeshChat
  class CLI
    # TODO: only include this and awesome_print when booted with
    # debug=true in the config
    class IRB < Command::Base
      def handle
        begin
          code = command_args[1..command_args.length].join(' ')
          ap eval(code)
          ''
        rescue => e
          ap e.message
          ap e.backtrace
        end
      end
    end
  end
end
