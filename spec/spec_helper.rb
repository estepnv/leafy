# frozen_string_literal: true

# Ruby 3.4+ compatibility: require bundled gems that are needed by dependencies
if RUBY_VERSION >= "3.4.0"
  require 'logger'
  require 'erb'
  require 'mutex_m'
  require 'base64'
  require 'bigdecimal'
  require 'csv'
  require 'drb'
end

require "bundler/setup"
require "leafy"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  if !!ENV['COVERAGE']
    require 'simplecov'
    SimpleCov.start
  end


  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand config.seed
end
