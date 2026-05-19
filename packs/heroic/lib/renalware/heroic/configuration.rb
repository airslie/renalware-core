# frozen_string_literal: true

# Class for configuring the Renalware::Heroic engine
#
# To override default config values, create an initializer in the host application
# e.g. config/initializers/renalware_heroic.rb, and use e.g.:
#
#   Renalware::Heroic.configure do |config|
#    config.x = y
#    ...
#   end
#
# To access configuration settings use e.g.
#   Renalware::Heroic.config.x
#
module Renalware
  module Heroic
    class Configuration
      include ActiveSupport::Configurable

      # Force dotenv to load the .env file at this stage so we can read in the config defaults.
      # Dotenv 3.x no longer provides Dotenv::Rails, so support both APIs.
      if defined?(Dotenv::Rails)
        Dotenv::Rails.load
      elsif defined?(Dotenv)
        Dotenv.load
      end

      config_accessor(:new_aliquot_deletion_window) { 24.hours }
      config_accessor(:new_aliquot_usage_edit_window) { 24.hours }
    end

    def self.config
      @config ||= Configuration.new
    end

    # Used in tests only! See ConfigurationHelpers
    def self.reset_config
      @config = nil
    end

    def self.configure
      yield config
    end
  end
end
