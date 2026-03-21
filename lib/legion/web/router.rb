# frozen_string_literal: true

module Legion
  module Web
    class Router
      Route = ::Data.define(:http_method, :path, :handler)

      def initialize
        @routes = []
      end

      def configure
        yield self
      end

      def get(path, to:)    = add_route(:GET, path, to)
      def post(path, to:)   = add_route(:POST, path, to)
      def put(path, to:)    = add_route(:PUT, path, to)
      def delete(path, to:) = add_route(:DELETE, path, to)

      def match(http_method, path)
        @routes.find { |r| r.http_method == http_method.to_sym && r.path == path }
      end

      def routes
        @routes.dup
      end

      private

      def add_route(http_method, path, handler)
        @routes << Route.new(http_method: http_method, path: path, handler: handler)
      end
    end
  end
end
