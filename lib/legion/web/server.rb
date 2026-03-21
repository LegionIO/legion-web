# frozen_string_literal: true

require 'rackup/handler/webrick'
require 'webrick'

module Legion
  module Web
    class Server
      def initialize(app:, port: 4568, host: '0.0.0.0', **)
        @app     = app
        @port    = port
        @host    = host
        @running = false
        @thread  = nil
      end

      def start
        null_logger = ::WEBrick::Log.new(::File.open(::File::NULL, 'w'))
        @thread = Thread.new do
          ::Rackup::Handler::WEBrick.run(
            @app,
            Port:      @port,
            Host:      @host,
            Logger:    null_logger,
            AccessLog: []
          )
        end
        @running = true
      end

      def stop
        @running = false
        @thread&.kill
        @thread&.join(2)
        @thread = nil
      end

      def running?
        @running && (@thread&.alive? || false)
      end
    end
  end
end
