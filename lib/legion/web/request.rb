# frozen_string_literal: true

require 'uri'

module Legion
  module Web
    class Request
      attr_reader :method, :path, :headers, :body, :params

      def initialize(env)
        @method  = env['REQUEST_METHOD'].to_sym
        @path    = env['PATH_INFO']
        @headers = extract_headers(env)
        @body    = env['rack.input']&.read
        @params  = parse_query(env['QUERY_STRING'])
      end

      private

      def extract_headers(env)
        env.each_with_object({}) do |(k, v), h|
          h[k.sub('HTTP_', '').downcase.tr('_', '-')] = v if k.start_with?('HTTP_')
        end
      end

      def parse_query(query_string)
        return {} if query_string.nil? || query_string.empty?

        ::URI.decode_www_form(query_string).to_h
      end
    end
  end
end
