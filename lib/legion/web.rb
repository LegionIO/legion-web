# frozen_string_literal: true

require 'legion/web/version'
require 'legion/web/router'
require 'legion/web/request'
require 'legion/web/response'
require 'legion/web/app'
require 'legion/web/server'

module Legion
  module Web
    class << self
      attr_accessor :router, :server

      def start(port: 4568, host: '0.0.0.0', **)
        @router ||= Router.new
        @server = Server.new(app: build_app, port: port, host: host, **)
        @server.start
      end

      def stop
        @server&.stop
      end

      def running?
        @server&.running? || false
      end

      def register(&)
        @router ||= Router.new
        @router.configure(&)
      end

      def reset!
        @router = nil
        @server = nil
      end

      def build_app
        App.new(router: @router)
      end
    end
  end
end
