# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Web::Server do
  let(:router) { Legion::Web::Router.new }
  let(:app)    { Legion::Web::App.new(router: router) }

  describe '#running?' do
    it 'is false before start' do
      server = described_class.new(app: app, port: 14_568)
      expect(server.running?).to be false
    end

    it 'is false after stop without ever starting' do
      server = described_class.new(app: app, port: 14_569)
      server.stop
      expect(server.running?).to be false
    end
  end

  describe '#start and #stop' do
    it 'becomes running? true after start and false after stop', :slow do
      server = described_class.new(app: app, port: 14_570)
      server.start
      sleep 0.3
      expect(server.running?).to be true
      server.stop
      expect(server.running?).to be false
    end
  end

  describe 'constructor defaults' do
    it 'accepts app, port, and host' do
      server = described_class.new(app: app, port: 4568, host: '127.0.0.1')
      expect(server).to be_a(described_class)
    end

    it 'accepts extra keyword args via **' do
      server = described_class.new(app: app, port: 4568, extra_opt: true)
      expect(server).to be_a(described_class)
    end
  end
end
