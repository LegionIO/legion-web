# frozen_string_literal: true

require 'spec_helper'
require 'rack/mock_request'

RSpec.describe Legion::Web::App do
  let(:router) { Legion::Web::Router.new }
  let(:app)    { described_class.new(router: router) }
  let(:mock)   { Rack::MockRequest.new(app) }

  describe '#call — 404 for unregistered routes' do
    it 'returns 404 when no routes match' do
      response = mock.get('/missing')
      expect(response.status).to eq 404
      expect(response.body).to include('not found')
    end
  end

  describe '#call — route dispatch' do
    before do
      stub_const('TestHandlers::Echo', Class.new do
        def call(request:)
          { echoed: request.path }
        end
      end)
      router.get '/echo', to: 'TestHandlers::Echo#call'
    end

    it 'dispatches to the registered handler' do
      response = mock.get('/echo')
      expect(response.status).to eq 200
      expect(response.body).to include('echoed')
    end

    it 'returns content-type application/json for Hash results' do
      response = mock.get('/echo')
      expect(response.content_type).to include('application/json')
    end
  end

  describe '#call — handler returning a raw Rack array' do
    before do
      stub_const('TestHandlers::Raw', Class.new do
        def call(**)
          [201, { 'content-type' => 'text/plain' }, ['created']]
        end
      end)
      router.post '/raw', to: 'TestHandlers::Raw#call'
    end

    it 'passes through raw Rack array responses' do
      response = mock.post('/raw')
      expect(response.status).to eq 201
      expect(response.body).to eq 'created'
    end
  end

  describe '#call — handler returning a plain string' do
    before do
      stub_const('TestHandlers::Plain', Class.new do
        def call(**)
          'pong'
        end
      end)
      router.get '/ping', to: 'TestHandlers::Plain#call'
    end

    it 'wraps plain strings in a 200 text/plain response' do
      response = mock.get('/ping')
      expect(response.status).to eq 200
      expect(response.body).to eq 'pong'
      expect(response.content_type).to include('text/plain')
    end
  end

  describe '#call — method mismatch' do
    before do
      stub_const('TestHandlers::OnlyPost', Class.new do
        def create(**)
          { ok: true }
        end
      end)
      router.post '/items', to: 'TestHandlers::OnlyPost#create'
    end

    it 'returns 404 when method does not match' do
      response = mock.get('/items')
      expect(response.status).to eq 404
    end
  end
end
