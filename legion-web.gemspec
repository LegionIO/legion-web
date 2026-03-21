# frozen_string_literal: true

require_relative 'lib/legion/web/version'

Gem::Specification.new do |spec|
  spec.name          = 'legion-web'
  spec.version       = Legion::Web::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'Shared HTTP server for the LegionIO framework'
  spec.description   = 'A shared, lightweight Rack-based HTTP server that any LegionIO extension can register routes against'
  spec.homepage      = 'https://github.com/LegionIO/legion-web'
  spec.license       = 'Apache-2.0'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.4'
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.extra_rdoc_files = %w[README.md LICENSE CHANGELOG.md]
  spec.metadata = {
    'bug_tracker_uri'       => 'https://github.com/LegionIO/legion-web/issues',
    'changelog_uri'         => 'https://github.com/LegionIO/legion-web/blob/main/CHANGELOG.md',
    'documentation_uri'     => 'https://github.com/LegionIO/legion-web',
    'homepage_uri'          => 'https://github.com/LegionIO/LegionIO',
    'source_code_uri'       => 'https://github.com/LegionIO/legion-web',
    'wiki_uri'              => 'https://github.com/LegionIO/legion-web/wiki',
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'rack', '>= 3.0'
  spec.add_dependency 'rackup'
  spec.add_dependency 'webrick'
end
