# frozen_string_literal: true

source "https://rubygems.org"
source "https://rails-assets.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 2.6.3"

gemspec

# These are visible to dummy app only
gem "aws-sdk-s3", require: false # for active storage when using Heroku for test environments
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "party_foul", "~> 1.5.5", github: "airslie/party_foul"
gem "redis"

gem "nhs_api_client", github: "airslie/nhs_api_client", require: false
# The main trix gem at https://github.com/maclover7/trix is not yet Rails 5.2 compatible; it give
# an argument error when calling f.trix_editor due to a Rails 5.2 ActionView change.
# For now use this fork until the upstream has been fixed (this line will also need to appear in
# each hospital's Gemfile for now)
gem "trix", github: "airslie/trix"

group :test do
  gem "capybara", "~> 3.24"
  gem "capybara-screenshot", "~> 1.0"
  gem "capybara-select-2"
  # gem "chromedriver-helper" # this clashses with the */*-browsers images in cirlci so removed
  gem "codeclimate-test-reporter", "~> 1.0.9", require: false # loads simplecov
  gem "cucumber-rails", "~> 1.8.0", require: false # must be loaded in env.rb
  gem "database_cleaner", "~> 1.7.0", require: false # for cucumber (now not needed for rspec)
  gem "factory_bot_rails", "~> 4.11"
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", "~> 0.9.1", require: false
  gem "rspec-rails", "~> 3.8"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "selenium-webdriver", "~> 3.142.0"
  gem "shoulda-matchers", "~> 4.1.0"
  gem "simplecov", require: false # only loaded if required
  gem "webmock", "~> 3.5", require: false
  gem "wisper-rspec", "~> 1.1.0"
end

group :staging do
  gem "newrelic_rpm"
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development do
  # gem "meta_request" # useful for https://github.com/dejan/rails_panel
  # gem "traceroute" # for finding unused routes
  gem "awesome_print", require: false
  gem "binding_of_caller"
  gem "bullet"
  gem "foreman", require: false
  gem "rubocop-performance"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  gem "launchy", require: false
  gem "rubocop", require: false
end
