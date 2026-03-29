# legion-web: Shared HTTP Server for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Shared HTTP server for the LegionIO framework. Any extension can register Rack routes at boot and a single WEBrick/Puma server handles all inbound HTTP traffic. Provides a lightweight alternative to the full Sinatra-based API in LegionIO for extensions that need custom HTTP endpoints.

**GitHub**: https://github.com/LegionIO/legion-web
**Version**: 0.1.1
**License**: Apache-2.0

## Architecture

```
Legion::Web (singleton module)
├── .register { |r| ... }    # Register routes at boot time
├── .start(port:)            # Start the HTTP server
├── .stop                    # Stop the server
├── .running?                # Whether the server is accepting connections
│
├── Router                   # In-memory route table (method + path -> handler string)
├── App                      # Rack application; resolves "Module::Class#method" strings to callables
├── Server                   # WEBrick lifecycle wrapper (start/stop/running?)
├── Request                  # Normalizes Rack env: method, path, headers, body, params
└── Response                 # Builds Rack triples from Hash, Array, or String results
```

## Key Design Patterns

- **Handler strings**: Routes are registered as `"Module::Class#method"` strings resolved lazily at call time
- **Multi-extension routing**: Multiple extensions register routes independently; all served by one server
- **Simple lifecycle**: `start`/`stop`/`running?` match the LegionIO subsystem lifecycle convention

## File Map

| Path | Purpose |
|------|---------|
| `lib/legion/web.rb` | Module entry, register, start, stop |
| `lib/legion/web/router.rb` | Route table (method + path -> handler) |
| `lib/legion/web/app.rb` | Rack application with handler resolution |
| `lib/legion/web/server.rb` | WEBrick lifecycle wrapper |
| `lib/legion/web/request.rb` | Rack env normalization |
| `lib/legion/web/response.rb` | Rack triple builder |
| `lib/legion/web/version.rb` | VERSION constant |

## Role in LegionIO

Optional HTTP server for extensions that need custom routes outside of the main LegionIO REST API. Extensions call `Legion::Web.register` during their boot phase to add routes.

Default port is **4568** (separate from the main daemon REST API on 4567). Both can run simultaneously.

---

**Maintained By**: Matthew Iverson (@Esity)
