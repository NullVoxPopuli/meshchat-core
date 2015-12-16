require 'sinatra/base'
require 'meshchat/net/listener/errors'

module MeshChat
  module Net
    module Listener
      class Server < Sinatra::Base
        OK = 200
        BAD_REQUEST = 400
        NOT_AUTHORIZED = 401
        FORBIDDEN = 403

        configure :development do
          # only shows resulting status
          disable :logging
          # enable :logging
          set :bind, '0.0.0.0' #['10.10.2.29','127.0.0.1', 'localhost']
          set :show_exceptions, :after_handler
          set :threaded, true
        end
        # TODO: do we want to return an error if
        # we can't decrypt?

        def self.run!(*)
          # any code that should be ran
          # before sintra starts should go here

          # start the server
          super
          # code after here will not run
        end

        get '/' do
          process_request
        end

        post '/' do
          process_request
        end

        def process_request
          begin
            # form params should override
            # raw body
            raw = get_message
            process(raw)
          rescue => e
            Display.error e.message
            Display.error e.backtrace.join("\n")
            body e.message
            status 500
          end
        end

        def get_message
          # if received as form data
          return params[:message] if params[:message]

          # if received as json
          request_body = request.body.read
          json_body = JSON.parse(request_body)
          json_body['message']
        end

        def process(raw)
          # decode, etc
          begin
            RequestProcessor.process(raw)
          rescue Errors::NotAuthorized
            status_of NOT_AUTHORIZED
          rescue Errors::Forbidden
            status_of FORBIDDEN
          rescue Errors::BadRequest
            status_of BAD_REQUEST
          end
        end

        def status_of(s)
          status s
          body ''
        end

        # Hack away our problems
        # don't show the Sinatra has taken the stage message
        #
        # https://github.com/sinatra/sinatra/blob/master/lib/sinatra/base.rb#L1504
        def self.start_server(handler, server_settings, handler_name)
          handler.run(self, server_settings) do |server|

            setup_traps
            set :running_server, server
            set :handler_name,   handler_name
            server.threaded = settings.threaded if server.respond_to? :threaded=

            yield server if block_given?
          end
        end

        # Hack away our problems
        # Don't show the Sinatra quit message
        #
        # https://github.com/sinatra/sinatra/blob/master/lib/sinatra/base.rb#L1420
        def self.quit!
          return unless running?
          # Use Thin's hard #stop! if available, otherwise just #stop.
          running_server.respond_to?(:stop!) ? running_server.stop! : running_server.stop
          set :running_server, nil
          set :handler_name, nil
        end
      end
    end
  end
end
