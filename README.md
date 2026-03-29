# legion-web

Shared HTTP server for the LegionIO framework. Any extension can register Rack routes at boot; a single WEBrick/Puma server handles all inbound HTTP traffic.

## Usage

```ruby
require 'legion/web'

Legion::Web.register do |r|
  r.post '/webhooks/github', to: 'Legion::Extensions::Github::Runners::Webhooks#receive'
  r.get  '/health',          to: 'Legion::Web::Health#check'
end

Legion::Web.start(port: 4568)   # default port; main daemon uses 4567
```

## Architecture

- **Router** — in-memory route table (method + path → handler string)
- **App** — Rack application; resolves `"Module::Class#method"` strings to callables
- **Server** — WEBrick lifecycle wrapper (start/stop/running?)
- **Request** — normalizes Rack env: method, path, headers, body, params
- **Response** — builds Rack triples from Hash, Array, or String results

## Installation

```ruby
gem 'legion-web'
```

## License

Apache-2.0
