# Class for configuring the Renalware::Core engine
# http://stackoverflow.com/questions/24104246/how-to-use-activesupportconfigurable-with-rails-engine
#
# To override default config values, create an initializer in the host application
# e.g. config/initializers/renalware_core.rb, and use e.g.:
#
#   Renalware.configure do |config|
#    config.x = y
#    ...
#   end
#
# To access configuration settings use e.g.
#   Renalware.config.x
#
module Renalware
  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:site_name) { "Renalware" }
    config_accessor(:hospital_name) { "KINGS COLLEGE HOSPITAL" }
    config_accessor(:delay_after_which_a_finished_session_becomes_immutable) { 6.hours }
    config_accessor(:new_clinic_visit_deletion_window) { 24.hours }
    config_accessor(:salutation_prefix) { "Dear" }
    config_accessor(:page_title_spearator) { " : " }
    config_accessor(:patient_hospital_identifiers) { {} }
    config_accessor(:session_timeout_polling_frequency) { 1.minute }
    config_accessor(:duration_of_last_url_memory_after_session_expiry) { 30.minutes }
    config_accessor(:broadcast_subscription_map) { {} }
    config_accessor(:include_sunday_on_hd_diaries) { false }
    config_accessor(:clinical_summary_max_events_to_display) { 10 }
    config_accessor(:clinical_summary_max_letters_to_display) { 10 }
    config_accessor(:display_feedback_banner) { false }
    # These settings are used in the construction of the IDENT metadata in letters
    config_accessor(:letter_system_name) { "Renalware" }
    config_accessor(:letter_default_care_group_name) { "RenalCareGroup" }
    config_accessor(:default_from_email) { "dev@airslie.com" }
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end
end
