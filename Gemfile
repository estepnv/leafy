source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in leafy.gemspec
gemspec

# Ruby 2.5+ bundled gems needed by ActiveRecord 6.0+
if RUBY_VERSION >= "2.5.0"
  gem 'logger'
end

# Ruby 3.0+ additional bundled gems
if RUBY_VERSION >= "3.0.0"
  gem 'mutex_m'
  gem 'base64'
end

# Ruby 3.1+ additional bundled gems
if RUBY_VERSION >= "3.1.0"
  gem 'csv'
end

# Ruby 3.4+ additional bundled gems
if RUBY_VERSION >= "3.4.0"
  gem 'erb'
  gem 'bigdecimal'
  gem 'drb'
end
