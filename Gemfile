ruby "2.5.0"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

# These are visible to dummy app only
gem "bootsnap", require: false # speeds up rspec and rails server boot time in development
gem "daemons", require: false # to use cmds like `bin/delayed_job start`
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
  gem "capybara"
  gem "capybara-screenshot"
  gem "codeclimate-test-reporter", require: false # loads simplecov
  gem "cucumber", "~> 3.1.0"
  gem "cucumber-rails", "~> 1.5.0", require: false # must be loaded in env.rb
  gem "database_cleaner", require: false # for cucumber specs, no longer needed for rspec features
  gem "factory_bot_rails"
  gem "fuubar", require: false
  gem "poltergeist"
  gem "rails-controller-testing"
  gem "rspec-html-matchers"
  gem "rspec-rails", "~> 3.7.0"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
  gem "simplecov", require: false # only loaded if required
  gem "webmock", require: false
  gem "wisper-rspec"
end

group :staging do
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development do
  gem "foreman", require: false
  gem "rubocop-rspec", require: false # for housekeeping
  gem "web-console", require: false
end

group :development, :test do
  gem "awesome_print", require: false
  gem "bullet"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "launchy", require: false
  gem "rack-mini-profiler", require: false
  gem "rubocop", "~> 0.52.0", require: false
  gem "spring"
  gem "spring-commands-cucumber", require: false
  gem "spring-commands-rspec", require: false
  gem "terminal-notifier-guard", require: false
end

group :test, :development, :staging do
  gem "faker"
end
