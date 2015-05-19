source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '~> 4.2'
gem 'pg', '~> 0.18.1'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'underscore-rails'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 4.0.3'
gem 'haml-rails'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'httparty'
gem 'paper_trail', '~> 3.0.6'
gem 'paranoia', '~> 2.0'
gem 'ransack', git: 'https://github.com/activerecord-hackery/ransack.git'
gem 'kaminari', '~> 0.15.1'
gem 'devise', '~> 3.4.1'
gem 'cancancan', '~> 1.10'

group :development, :test do
  gem 'capybara', '2.4.4'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'ffaker'
  gem 'launchy'
  gem 'mocha'
  gem 'poltergeist', '~> 1.5.1'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rspec-expectations'
  gem 'shoulda-matchers'
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
  gem 'rubocop', require: false
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
  gem 'unicorn'
end
