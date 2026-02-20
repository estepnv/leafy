# frozen_string_literal: true

# Ruby 2.5+ compatibility: logger needed by ActiveRecord 6.0+
if RUBY_VERSION >= "2.5.0"
  require 'logger'
end

# Ruby 3.0+ compatibility: require bundled gems that are needed by dependencies
if RUBY_VERSION >= "3.0.0"
  require 'mutex_m'
  require 'base64'
  require 'benchmark'  # Needed by ActiveSupport in Ruby 3.3+/4.x
end

# Ruby 3.1+ additional bundled gems
if RUBY_VERSION >= "3.1.0"
  require 'csv'
end

# Ruby 3.4+ additional bundled gems
if RUBY_VERSION >= "3.4.0"
  require 'erb'
  require 'bigdecimal'
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
