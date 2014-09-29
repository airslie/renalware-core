# begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-webkit' # I added this
require 'pry'

Capybara.app_host = "http://localhost"

Capybara.default_driver = :webkit # And changed this!