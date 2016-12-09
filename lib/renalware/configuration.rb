# Class for setting configuration options in this engine.
# http://stackoverflow.com/questions/24104246/how-to-use-activesupportconfigurable-with-rails-engine
#
# To override default config values, for example in an initaliser, use e.g.:
#
#   Renalware.configure do |config|
#    config.x = y
#   end
#
# To access configuration settings use e.g.
#   Renalware.config.x
#
module Renalware
  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:site_name) { "Renalware" }
    config_accessor(:delay_after_which_a_finished_session_becomes_immutable) { 6.hours }
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end
end
