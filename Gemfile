# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gemspec

# These are visible to dummy app only
gem "aws-sdk-s3", require: false # for active storage when using Heroku for test environments
gem "babel-transpiler" # not sure this is need now that we user rollupjs + babel npmm packages?
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "nhs_api_client", github: "airslie/nhs_api_client", require: false
gem "paper_trail"
gem "party_foul", "~> 1.5.5", github: "airslie/party_foul"
gem "redis"
gem "renalware-forms", "0.1.10"
# gem "renalware-forms", path: "../renalware-forms"
gem "ruby-prof", require: false
# gem "sprockets-rails", "~> 2.3.3" # in the dummy app, fix to this version to avoid manifest errors

group :test do
  gem "capybara", "~> 3.32"
  gem "capybara-screenshot", "~> 1.0"
  gem "capybara-select-2"
  gem "cucumber-rails", "~> 2.0", require: false # must be loaded in env.rb
  gem "database_cleaner", require: false # for cucumber (now not needed for rspec)
  gem "factory_bot_rails", "~> 6.1"
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.4"
  gem "rspec-html-matchers", "~> 0.9.1", require: false
  gem "rspec_junit_formatter", "~> 0.4.1"
  gem "rspec-rails"
  gem "rspec-retry"
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
  gem "bullet"
  gem "foreman", require: false
  gem "rubocop-performance"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "turnip", "~> 4.0", require: false
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  gem "launchy", require: false
  gem "pry-byebug", require: false
  gem "pry-rails", require: false
  gem "rubocop", require: false
end
