# frozen_string_literal: true

module Legion
  module Web
    class App
      def initialize(router:)
        @router = router
      end

      def call(env)
        request = Request.new(env)
        route = @router.match(request.method, request.path)

        if route
          handler = resolve_handler(route.handler)
          result = handler.call(request)
          Response.build(result)
        else
          [404, { 'content-type' => 'application/json' }, ['{"error":"not found"}']]
        end
      end

      private

      def resolve_handler(handler_string)
        klass_name, method_name = handler_string.split('#')
        klass = ::Object.const_get(klass_name)
        ->(req) { klass.new.public_send(method_name, request: req) }
      end
    end
  end
end
