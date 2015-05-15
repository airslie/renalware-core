require 'devise'
require './spec/support/login_macros'

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include LoginMacros, :type => :controller
end
