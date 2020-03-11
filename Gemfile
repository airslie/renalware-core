# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ">= 2.6.3"

gemspec

# These are visible to dummy app only
gem "aws-sdk-s3", require: false # for active storage when using Heroku for test environments
gem "babel-transpiler"
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "paper_trail", "9.0.2"
gem "party_foul", "~> 1.5.5", github: "airslie/party_foul"
gem "redis"
gem "ruby-prof", require: false
# gem "renalware-forms", path: "../renalware-forms"

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
  gem "cucumber-rails", "~> 2.0", require: false # must be loaded in env.rb
  gem "database_cleaner", "~> 1.8.0", require: false # for cucumber (now not needed for rspec)
  gem "factory_bot_rails", "~> 5.1"
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", "~> 0.9.1", require: false
  gem "rspec-rails", "~> 3.9"
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "selenium-webdriver", "~> 3.142.0"
  gem "shoulda-matchers", "~> 4.1"
  gem "simplecov", "~> 0.17.1", require: false # only loaded if required
  gem "test-prof"
  gem "webmock", "~> 3.7", require: false
  gem "wisper-rspec", "~> 1.1.0"
end

group :staging do
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
  gem "turnip", "~> 3.1", require: false
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  gem "launchy", require: false
  gem "pry-byebug", require: false
  gem "pry-rails", require: false
  gem "rubocop", require: false
end
