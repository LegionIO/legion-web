# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Web::Request do
  def build_env(method: 'GET', path: '/test', query: '', body: '', headers: {})
    env = {
      'REQUEST_METHOD' => method,
      'PATH_INFO'      => path,
      'QUERY_STRING'   => query,
      'rack.input'     => StringIO.new(body)
    }
    headers.each { |k, v| env["HTTP_#{k.upcase.tr('-', '_')}"] = v }
    env
  end

  describe '#method' do
    it 'returns the HTTP method as a symbol' do
      req = described_class.new(build_env(method: 'POST'))
      expect(req.method).to eq :POST
    end

    it 'handles GET' do
      req = described_class.new(build_env(method: 'GET'))
      expect(req.method).to eq :GET
    end
  end

  describe '#path' do
    it 'returns the request path' do
      req = described_class.new(build_env(path: '/webhooks/github'))
      expect(req.path).to eq '/webhooks/github'
    end
  end

  describe '#headers' do
    it 'extracts HTTP_ prefixed headers and normalizes them' do
      req = described_class.new(build_env(headers: { 'X-Hub-Signature' => 'sha256=abc' }))
      expect(req.headers['x-hub-signature']).to eq 'sha256=abc'
    end

    it 'ignores non-HTTP_ env keys' do
      env = build_env
      env['SERVER_NAME'] = 'localhost'
      req = described_class.new(env)
      expect(req.headers.key?('server_name')).to be false
      expect(req.headers.key?('server-name')).to be false
    end

    it 'returns empty hash when no HTTP headers' do
      req = described_class.new(build_env)
      expect(req.headers).to be_a(Hash)
    end
  end

  describe '#body' do
    it 'reads the request body' do
      req = described_class.new(build_env(body: '{"key":"value"}'))
      expect(req.body).to eq '{"key":"value"}'
    end

    it 'returns empty string for no body' do
      req = described_class.new(build_env(body: ''))
      expect(req.body).to eq ''
    end
  end

  describe '#params' do
    it 'parses query string parameters' do
      req = described_class.new(build_env(query: 'foo=bar&baz=qux'))
      expect(req.params['foo']).to eq 'bar'
      expect(req.params['baz']).to eq 'qux'
    end

    it 'returns empty hash for blank query string' do
      req = described_class.new(build_env(query: ''))
      expect(req.params).to eq({})
    end

    it 'returns empty hash when QUERY_STRING is nil' do
      env = build_env
      env.delete('QUERY_STRING')
      env['QUERY_STRING'] = nil
      req = described_class.new(env)
      expect(req.params).to eq({})
    end

    it 'handles URL-encoded values' do
      req = described_class.new(build_env(query: 'name=hello+world'))
      expect(req.params['name']).to eq 'hello world'
    end
  end
end
