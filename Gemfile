ruby "2.4.1"

source "https://rubygems.org"
source "https://rails-assets.org"

gemspec

# These are visible to dummy app only
gem "devise_security_extension", git: "https://github.com/phatworx/devise_security_extension.git"
gem "rollbar"

group :test do
  gem "codeclimate-test-reporter", require: false
  gem "cucumber-rails", "~> 1.5.0", require: false
  gem "rails-controller-testing"
  gem "simplecov", "~> 0.13.0", require: false
  gem "webmock"
  gem "wisper-rspec", require: false
  gem "rspec_junit_formatter"
end

group :staging do
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development, :test, :staging do
  gem "faker", "~> 1.7.3"
end
