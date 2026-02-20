source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in leafy.gemspec
gemspec

# Ruby 3.4+ bundled gems that need explicit declaration
if RUBY_VERSION >= "3.4.0"
  gem 'erb'
  gem 'logger'
  gem 'mutex_m'
  gem 'base64'
  gem 'bigdecimal'
  gem 'csv'
  gem 'drb'
end
