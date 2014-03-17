source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

gem 'nokogiri'
gem 'countries'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "shoulda", ">= 0"
  gem "rdoc", "~> 3.12"
  gem "bundler", "~> 1.0"
  gem "jeweler", "~> 1.8.7"
  gem "simplecov", ">= 0", :require => false

  gem 'parallel_tests'
  gem 'zeus-parallel_tests'
  gem 'terminal-notifier-guard'
end

group :test do
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'timecop'
end

group :test, :development do
  gem 'rspec'
  gem 'guard-rspec'
end