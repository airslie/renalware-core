source "https://rubygems.org"
ruby "2.3.3"

gem "active_type", "~> 0.6.1"
gem "activemodel-associations"
gem "autoprefixer-rails"
gem "chosen-rails"
gem "client_side_validations"
gem "client_side_validations-simple_form"
gem "clipboard-rails"
gem "cocoon"
gem "delayed_job_active_record"
gem "delayed_job_web"
gem "devise"
gem "devise_security_extension", git: "https://github.com/phatworx/devise_security_extension.git"
gem "dumb_delegator"
gem "email_validator"
gem "enumerize"
gem "font-awesome-rails" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
gem "foundation-rails", "~> 5.5.3.2"
gem "hashdiff"
gem "httparty"
gem "jbuilder"
gem "jquery-rails" # , "~> 4.2.1"
gem "jquery-ui-rails" # , "~> 5.0.5"
gem "kaminari"
gem "naught", "~> 1.1.0"
gem "nested_form"
gem "nokogiri"
gem "paper_trail"
gem "paranoia"
gem "pg"
gem "pundit", "~> 1.1.0"
gem "rails", "5.0.2"
gem "ransack", git: "https://github.com/activerecord-hackery/ransack.git"
gem "record_tag_helper", "~> 1.0"
gem "rollbar"
gem "ruby-hl7", "~> 1.1.1"
gem "sass-rails"
gem "scenic"
gem "sdoc", "~> 0.4.0", group: :doc
gem "simple_form"
gem "sinatra", git: "https://github.com/sinatra/sinatra.git"
gem "slim-rails"
gem "uglifier"
gem "underscore-rails"
gem "validates_timeliness"
gem "virtus"
gem "whenever", require: false # For managing and deploying cron jobs - see config/schedule.rb
gem "wicked_pdf", "~> 1.0.6"
gem "wisper"
gem "wkhtmltopdf-binary", "~> 0.12.3"
gem "puma"

source "https://rails-assets.org" do
  gem "rails-assets-clockpicker", "~> 0.0.7"
  # https://github.com/najlepsiwebdesigner/foundation-datepicker
  gem "rails-assets-foundation-datepicker", "1.5.0"
  gem "rails-assets-select2", "~> 4.0.2"
end

group :development do
  gem "awesome_print"
  gem "bullet"
  gem "guard-cucumber", require: false
  gem "guard-rspec", require: false
  gem "rack-mini-profiler"
  gem "terminal-notifier-guard"
  gem "web-console"
end

group :development, :test do
  gem "bundler-audit", require: false
  gem "byebug"
  gem "capybara"
  gem "capybara-screenshot"
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "foreman"
  gem "launchy"
  gem "poltergeist" # , "~> 1.11.0"
  gem "rspec-html-matchers"
  gem "rspec-rails"
  gem "rubocop", "~> 0.45.0", require: false
  gem "shoulda-matchers"
  gem "spring"
  gem "spring-commands-cucumber"
  gem "spring-commands-rspec"
  gem "thin"
end

group :test do
  gem "rails-controller-testing"
  gem "simplecov", "~> 0.12.0", require: false
  gem "webmock", "~> 1.20.4"
  gem "wisper-rspec", require: false
end

group :staging do
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development, :test, :staging do
  gem "activerecord-import", "~> 0.16.2"
  gem "faker", "~> 1.6.6"
end
