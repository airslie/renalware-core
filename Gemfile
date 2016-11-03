source "https://rubygems.org"
ruby "2.3.1"

gem "rails", "~> 4.2.7"
gem "pg", "~> 0.19.0"
gem "foundation-rails", "~> 5.4.5"
gem "jquery-rails", "~> 4.2.1"
gem "jquery-ui-rails", "~> 5.0.5"
gem "underscore-rails", "~> 1.8.3"
gem "uglifier", ">= 1.3.0"
gem "sass-rails", "~> 4.0.5"
gem "sdoc", "~> 0.4.0", group: :doc
gem "httparty", "~> 0.14.0"
gem "paper_trail", "~> 4.0.0"
gem "paranoia", "~> 2.2.0"
gem "ransack", git: "https://github.com/activerecord-hackery/ransack.git"
gem "kaminari", "~> 0.15.1"
gem "devise", "~> 3.5.4"
gem "devise_security_extension", git: "https://github.com/phatworx/devise_security_extension.git"
gem "nested_form", "~> 0.3.2"
gem "slim-rails", "~> 3.1.1"
gem "simple_form", "~> 3.3.1"
gem "virtus", "~> 1.0.5"
gem "hashdiff", "~> 0.2.2"
gem "enumerize", "~> 1.0.0"
gem "validates_timeliness", "~> 3.0.14"
gem "pundit", "~> 1.1.0"
gem "font-awesome-rails", "~> 4.4.0.0" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
gem "jbuilder", "~> 2.4.0"
gem "active_type", "~> 0.4.3"
gem "dumb_delegator", "~> 0.8.0"
gem "ruby-hl7", "~> 1.1.1"
gem "delayed_job_active_record", "~> 4.1.1"
gem "wisper", "2.0.0.rc1"
gem "cocoon", "~> 1.2.9"
gem "email_validator", "~> 1.6.0"
gem "nokogiri", "~> 1.6.8"
gem "activemodel-associations", "~> 0.1.2"
gem "wicked_pdf", "~> 1.0.6"
gem "wkhtmltopdf-binary", "~> 0.12.3"
gem "activerecord-tableless", "~> 1.3.4"

source "https://rails-assets.org" do
  # https://github.com/najlepsiwebdesigner/foundation-datepicker
  gem "rails-assets-foundation-datepicker", "~> 1.5.0"
  gem "rails-assets-clockpicker", "~> 0.0.7"
  gem "rails-assets-select2", "~> 4.0.2"
end

group :development do
  gem "guard-rspec", "4.7.3", require: false
  gem "guard-cucumber", "~> 2.1.2", require: false
  gem "awesome_print", "~> 1.7.0"
  gem "bullet", "~> 5.4"
  gem "rack-mini-profiler"
end

group :development, :test do
  gem "bundler-audit", "~> 0.4.0", require: false
  gem "capybara", "~> 2.10.1"
  gem "cucumber-rails", "~> 1.4.5", require: false
  gem "database_cleaner", "~> 1.5.3"
  gem "factory_girl_rails", "~> 4.7.0"
  gem "foreman", "~> 0.82.0"
  gem "launchy", "~> 2.4.3"
  gem "poltergeist", "~> 1.11.0"
  gem "byebug"
  gem "quiet_assets", "~> 1.1.0"
  gem "rspec-rails", "~> 3.5.2"
  gem "rspec-html-matchers", "~> 0.8.1"
  gem "shoulda-matchers", "~> 2.7.0"
  gem "spring", "~> 1.7.2"
  gem "spring-commands-cucumber", "~> 1.0.1"
  gem "spring-commands-rspec", "~> 1.0.4"
  gem "rubocop", "~> 0.37.0", require: false
  gem "web-console", "~> 2.0"
  gem "thin"
end

group :test do
  gem "simplecov", "~> 0.12.0", require: false
  gem "webmock", "~> 1.20.4"
  gem "wisper-rspec", require: false
end

group :staging do
  gem "rails_12factor", "~> 0.0.3"
  gem "unicorn", "~> 4.8.3"
  gem "wkhtmltopdf-heroku", "~> 2.12.3"
end

group :development, :test, :staging do
  gem "faker", "~> 1.6.6"
end
