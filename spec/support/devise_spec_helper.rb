require 'devise'
require './spec/support/login_macros'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include LoginMacros, type: :controller

  config.include Warden::Test::Helpers, type: :feature

  config.before(:each, type: :controller) do
    login_user
  end

  config.before :suite do
    Warden.test_mode!
  end

  config.after :each do
    Warden.test_reset!
  end
end
