# frozen_string_literal: true

require 'json'

module Legion
  module Web
    module Response
      module_function

      def build(result)
        case result
        when Array
          result
        when Hash
          body = result.to_json
          [200, { 'content-type' => 'application/json' }, [body]]
        else
          [200, { 'content-type' => 'text/plain' }, [result.to_s]]
        end
      end
    end
  end
end
