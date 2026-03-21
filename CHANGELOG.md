# Changelog

## [0.1.0] - 2026-03-21

### Added
- Initial release of `legion-web` shared HTTP server for LegionIO
- `Legion::Web::Router` — route registry DSL (GET, POST, PUT, DELETE)
- `Legion::Web::App` — Rack application with handler dispatch and `"Module::Class#method"` resolution
- `Legion::Web::Server` — WEBrick-backed lifecycle wrapper (start/stop/running?)
- `Legion::Web::Request` — Rack env wrapper with method, path, headers, body, params
- `Legion::Web::Response` — Rack response builder (Hash, Array, plain string)
- `Legion::Web.register` — DSL for extensions to register routes at boot
- `Legion::Web.start` / `.stop` / `.running?` — top-level lifecycle API
- Default port 4568 (separate from LegionIO API on 4567)
