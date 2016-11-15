# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nine_one_one/version'

Gem::Specification.new do |spec|
  spec.name          = 'nine_one_one'
  spec.version       = NineOneOne::VERSION
  spec.authors       = ['Kacper Madej', 'Marek Mateja']
  spec.email         = %w(kacper.madej@u2i.com marek.mateja@u2i.com)

  spec.summary       = %q{PagerDuty integration for Ruby apps}
  spec.homepage      = 'https://github.com/u2i/nine_one_one'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.1'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  spec.add_development_dependency 'simplecov'
end
