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
          # start the server
          super

          # send a pingall to see who's online
          MeshChat::Command::PingAll.new.handle
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
      end
    end
  end
end
