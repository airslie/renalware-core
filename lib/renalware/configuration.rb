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

    # Force dotenv to load the .env file at this stage so we can read in the config defaults
    Dotenv::Railtie.load

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
    # These settings are used in the construction of the IDENT metadata in letters
    config_accessor(:letter_system_name) { "Renalware" }
    config_accessor(:letter_default_care_group_name) { "RenalCareGroup" }
    config_accessor(:default_from_email) { "dev@airslie.com" }
    config_accessor(:display_feedback_banner) { ENV.key?("DISPLAY_FEEDBACK_BANNER") }
    config_accessor(:default_from_email_address) { ENV["DEFAULT_FROM_EMAIL_ADDRESS"] }
    config_accessor(:phone_number_on_letters) { ENV["PHONE_NUMBER_ON_LETTERS"] }
    config_accessor(:renal_unit_on_letters) { ENV["RENAL_UNIT_ON_LETTERS"] }
    # Unless an ALLOW_EXTERNAL_MAIL key is present in .env or .env.production, mail (other than
    # password reset emails etc) will be redirected to last user to update the relevant record
    # eg the use how approved the letter.
    config_accessor(:allow_external_mail) { ENV.key?("ALLOW_EXTERNAL_MAIL") }
    config_accessor(:fallback_email_address_for_test_messages) do
      ENV["FALLBACK_EMAIL_ADDRESS_FOR_TEST_MESSAGES"]
    end
    config_accessor(:ukrdc_sending_facility_name) { ENV["UKRDC_SENDING_FACILITY_NAME"] }
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield config
  end
end
