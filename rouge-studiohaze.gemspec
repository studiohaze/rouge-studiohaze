# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'rouge-studiohaze'
  spec.version = '0.1.0'
  spec.authors = ['STUDIO HAZE']
  spec.summary = 'Topaz and Lispex syntax highlighting for Rouge'
  spec.homepage = 'https://github.com/studiohaze/rouge-studiohaze'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'
  spec.files = Dir['lib/**/*.rb'] + ['README.md', 'LICENSE']
  spec.require_paths = ['lib']
  spec.add_dependency 'rouge', '>= 4.0', '< 6'
end
