source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '~> 4.2'
gem 'pg', '~> 0.18.1'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'underscore-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 4.0.3'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'httparty'
gem 'paper_trail', '~> 4.0.0'
gem 'paranoia', '~> 2.0'
gem 'ransack', git: 'https://github.com/activerecord-hackery/ransack.git'
gem 'kaminari', '~> 0.15.1'
gem 'devise', '~> 3.4.1'
gem 'devise_security_extension', git: 'https://github.com/phatworx/devise_security_extension.git'
gem 'cancancan', '~> 1.10'
gem 'nested_form', '~> 0.3.2'
gem 'slim-rails'

group :development do
  gem 'guard-rspec', require: false
  gem 'guard-cucumber', require: false
end

group :development, :test do
  gem 'capybara', '2.4.4'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'ffaker'
  gem 'foreman'
  gem 'launchy'
  gem 'mocha'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'rspec-expectations'
  gem 'rspec-html-matchers'
  gem 'shoulda-matchers'
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
  gem 'rubocop', require: false
  gem 'web-console', '~> 2.0'

  gem 'haml2slim' # TODO: remove when we're done moving to Slim
end

group :test do
  gem 'simplecov', require: false
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end
