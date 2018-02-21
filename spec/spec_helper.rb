require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nine_one_one'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock

  config.default_cassette_options = { match_requests_on: %i[method uri body path] }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
