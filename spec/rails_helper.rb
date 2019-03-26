# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"

# We only run simple on CiricleCI or if you set the SIMPLECOV env var
if ENV.key?("CC_TEST_REPORTER_ID") || ENV.key?("SIMPLECOV")
  require "simplecov"
  SimpleCov.command_name "RSpec"
end

require File.expand_path("dummy/config/environment", __dir__)
require "spec_helper"
require "fuubar"
require "rspec/rails"
require "factory_bot_rails"
require "wisper/rspec/matchers"
require "rspec-html-matchers"
require "rails-controller-testing"
require "byebug"
require "shoulda/matchers"
require "pundit/rspec"
require "paper_trail/frameworks/rspec"
require "chosen-rails/rspec"
require_relative "../lib/test_support/text_editor_helpers"

require "capybara/rspec"
require "capybara-screenshot/rspec"

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Renalware::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # System tests use Rack::Test for non JS test and headless Chrome for JS specs
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  Capybara.register_driver(:rw_headless_chrome) do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      # This makes logs available, but doesn't cause them to appear
      # in real time on the console
      loggingPrefs: {
        browser: "ALL",
        client: "ALL",
        driver: "ALL",
        server: "ALL"
      }
    )

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 10000
    client.open_timeout = 10000

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("window-size=1366,1768")
    options.add_argument("headless")
    options.add_argument("disable-gpu")
    options.add_argument("disable-dev-shm-usage")
    # options.add_argument("whitelisted-ips") # required for circleci to work
    options.add_argument("no-sandbox")
    # options.add_argument("privileged")

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities,
      options: options
    )
  end

  config.before(:each, type: :system, js: true) do
    driven_by :rw_headless_chrome
  end

  config.example_status_persistence_file_path = "#{::Rails.root}/tmp/examples.txt"

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include Renalware::Engine.routes.url_helpers
  config.include Wisper::RSpec::BroadcastMatcher
  config.include CapybaraHelper, type: :system
  config.include SelectDateSpecHelper, type: %i(system feature)
  config.include TextEditorHelpers, type: :system
  config.include CapybaraSelect2, type: :system
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Chosen::Rspec::FeatureHelpers, type: :system
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.fuubar_progress_bar_options = { progress_mark: "≈" }

  # By default, all specs will have versioning enabled.
  # Enable it one spec/example_group at a time by adding `versioning: true`.
  # Or you can enable it globally:
  #   config.before(:each) do
  #    ::PaperTrail.enabled = true
  #   end
  # See https://github.com/airblade/paper_trail#7b-rspec for more information.
end
