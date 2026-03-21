# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Web::Router do
  subject(:router) { described_class.new }

  describe '#routes' do
    it 'starts empty' do
      expect(router.routes).to be_empty
    end
  end

  describe 'route registration' do
    it 'registers a GET route' do
      router.get '/health', to: 'MyHandler#check'
      expect(router.routes.size).to eq 1
      expect(router.routes.first.http_method).to eq :GET
      expect(router.routes.first.path).to eq '/health'
      expect(router.routes.first.handler).to eq 'MyHandler#check'
    end

    it 'registers a POST route' do
      router.post '/events', to: 'MyHandler#receive'
      route = router.routes.first
      expect(route.http_method).to eq :POST
      expect(route.path).to eq '/events'
    end

    it 'registers a PUT route' do
      router.put '/items/1', to: 'MyHandler#update'
      route = router.routes.first
      expect(route.http_method).to eq :PUT
    end

    it 'registers a DELETE route' do
      router.delete '/items/1', to: 'MyHandler#destroy'
      route = router.routes.first
      expect(route.http_method).to eq :DELETE
    end

    it 'registers multiple routes' do
      router.get '/a', to: 'A#index'
      router.post '/b', to: 'B#create'
      expect(router.routes.size).to eq 2
    end
  end

  describe '#match' do
    before do
      router.get '/ping', to: 'Ping#call'
      router.post '/data', to: 'Data#receive'
    end

    it 'matches a registered route by method and path' do
      route = router.match(:GET, '/ping')
      expect(route).not_to be_nil
      expect(route.handler).to eq 'Ping#call'
    end

    it 'matches a POST route' do
      route = router.match(:POST, '/data')
      expect(route).not_to be_nil
      expect(route.handler).to eq 'Data#receive'
    end

    it 'returns nil for an unregistered path' do
      expect(router.match(:GET, '/missing')).to be_nil
    end

    it 'returns nil when method does not match' do
      expect(router.match(:POST, '/ping')).to be_nil
    end

    it 'accepts string method and converts to symbol' do
      route = router.match('GET', '/ping')
      expect(route).not_to be_nil
    end
  end

  describe '#configure' do
    it 'accepts a block and yields self' do
      router.configure do |r|
        r.get '/configured', to: 'Handler#action'
      end
      expect(router.routes.size).to eq 1
      expect(router.routes.first.path).to eq '/configured'
    end
  end

  describe 'Route struct' do
    it 'is immutable (Data.define)' do
      route = Legion::Web::Router::Route.new(http_method: :GET, path: '/x', handler: 'H#m')
      expect(route.http_method).to eq :GET
      expect(route.path).to eq '/x'
      expect(route.handler).to eq 'H#m'
    end
  end
end
