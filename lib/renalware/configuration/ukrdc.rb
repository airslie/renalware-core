module Renalware
  class Configuration
    module UKRDC
      def self.included(base)
        register_core_settings(base)
        register_file_settings(base)
        register_sftp_settings(base)
        register_patient_scope_settings(base)
      end

      def self.register_core_settings(base)
        base.config_accessor(:ukrdc_enabled) do
          ActiveModel::Type::Boolean.new.cast(ENV.fetch("UKRDC_ENABLED", "true"))
        end

        base.config_accessor(:ukrdc_include_letters) do
          ActiveModel::Type::Boolean.new.cast(ENV.fetch("UKRDC_INCLUDE_LETTERS", "true"))
        end

        base.config_accessor(:ukrdc_sending_facility_name) do
          ENV.fetch("UKRDC_SENDING_FACILITY_NAME", nil)
        end

        base.config_accessor(:ukrdc_schema_version) { ENV.fetch("UKRDC_SCHEMA_VERSION", "3.3.1") }

        base.config_accessor(:ukrdc_default_changes_since_date) do
          Date.parse(ENV.fetch("UKRDC_DEFAULT_CHANGES_SINCE_DATE", "2018-01-01"))
        end

        base.config_accessor(:ukrdc_gpg_recipient) do
          ENV.fetch("UKRDC_GPG_RECIPIENT", "Patient View (Renal)") # or "UKRDC"
        end

        base.config_accessor(:ukrdc_public_key_name) do
          ENV.fetch("UKRDC_PUBLIC_KEY_NAME", "patientview.asc") # might become ukrdc.asc
        end

        base.config_accessor(:ukrdc_working_path) do
          ENV.fetch("UKRDC_WORKING_PATH", File.join("/var", "ukrdc"))
        end

        base.config_accessor(:ukrdc_site_code) { ENV.fetch("UKRDC_PREFIX", "RJZ") }
      end

      def self.register_file_settings(base)
        base.config_accessor(:ukrdc_number_of_archived_folders_to_keep) do
          ENV.fetch("UKRDC_NUMBER_OF_ARCHIVED_FOLDERS_TO_KEEP", "7")
        end

        base.config_accessor(:ukrdc_remove_stale_outgoing_files) do
          ENV.fetch("UKRDC_REMOVE_STALE_OUTGOING_FILES", "true") == "true"
        end
      end

      def self.register_sftp_settings(base)
        base.config_accessor(:ukrdc_sftp_host) { ENV.fetch("UKRDC_SFTP_HOST", nil) }
        base.config_accessor(:ukrdc_sftp_user) { ENV.fetch("UKRDC_SFTP_USER", nil) }
        base.config_accessor(:ukrdc_sftp_password) { ENV.fetch("UKRDC_SFTP_PASSWORD", nil) }
        base.config_accessor(:ukrdc_sftp_port) { ENV.fetch("UKRDC_SFTP_PORT", 22) }
        base.config_accessor(:ukrdc_sftp_remote_path) { ENV.fetch("UKRDC_SFTP_REMOTE_PATH", "") }
      end

      def self.register_patient_scope_settings(base)
        base.config_accessor(:ukrdc_child_data_lookback_days) do
          [Integer(ENV.fetch("UKRDC_CHILD_DATA_LOOKBACK_DAYS", "30")), 0].max
        end

        # To use a date other that the default changes_since date when
        # compiling pathology to send to UKRDC, you can set an ENV var as follows:
        #   UKRDC_PATHOLOGY_START_DATE=01-01-2011
        # in the .env file (or e.g. .env.production) and we will always fetch pathology
        # from this date on. It only affects pathology and not medications, letters etc.
        # It is not indented to keep this date set, but its useful if UKRDC ask for
        # a dump of historical pathology.
        base.config_accessor(:ukrdc_pathology_start_date) do
          ENV.fetch("UKRDC_PATHOLOGY_START_DATE", nil)
        end

        base.config_accessor(:ukrdc_send_rpv_patients) do
          ENV.fetch("UKRDC_SEND_RPV_PATIENTS", "true") == "true"
        end

        base.config_accessor(:ukrdc_send_rreg_patients) do
          ENV.fetch("UKRDC_SEND_RREG_PATIENTS", "true") == "true"
        end
      end
    end
  end
end
