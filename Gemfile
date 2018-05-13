ruby "2.5.0"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

# These are visible to dummy app only
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
gem "faker"
gem "party_foul", "~> 1.5.5"
#
# devise_security_extension
#
# NB for now you will need to put this into the host app's Gemfile also.
# Once latest devise_security_extension changes are released uncomment this line.
# (check version has not bumped to 11 though). In the meantime, because we cannot use git
# references in the gemspec, we add this gem in the host app.
# The issue with the gem version of 0.10.0 is it requires rails < v5
# The master branch has this fixed so we are using that.
# Perhaps we should fork this into our own repo/gem.
gem "devise_security_extension",
    git: "https://github.com/phatworx/devise_security_extension.git"

group :test do
  gem "capybara" # "~> 2.17.0"
  gem "capybara-screenshot" # "~> 1.0.18"
  gem "chromedriver-helper"
  gem "selenium-webdriver"
  gem "codeclimate-test-reporter", "~> 1.0.7", require: false # loads simplecov
  gem "cucumber", "~> 3.1.0"
  gem "cucumber-rails", "~> 1.6.0", require: false # must be loaded in env.rb
  gem "database_cleaner", "~> 1.7.0", require: false # for cucumber (now not needed for rspec)
  gem "factory_bot_rails", "~> 4.8.2"
  gem "fuubar", require: false
  gem "rails-controller-testing", "~> 1.0.2"
  gem "rspec-html-matchers", "~> 0.9.1"
  gem "rspec-rails", "~> 3.7.0"
  gem "rspec_junit_formatter", "~> 0.3.0"
  gem "shoulda-matchers", "~> 3.1.2"
  gem "simplecov", "~> 0.16.0", require: false # only loaded if required
  gem "webmock", "~> 3.4.0", require: false
  gem "wisper-rspec", "~> 1.0.0"
end

group :staging do
  gem "newrelic_rpm"
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development do
  gem "awesome_print", require: false
  gem "bullet"
  gem "foreman", require: false
  # gem "meta_request" # useful for https://github.com/dejan/rails_panel
  gem "rubocop-rspec", require: false # for housekeeping
  # gem "traceroute" # for finding unused routes
  gem "web-console", require: false
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  gem "launchy", require: false
  gem "rubocop", "~> 0.55.0", require: false
  gem "spring"
  gem "spring-commands-cucumber", require: false
  gem "spring-commands-rspec", require: false
  gem "terminal-notifier-guard", require: false
end

group :staging, :production do
  gem "redis-rails", "5.0.2"
end
