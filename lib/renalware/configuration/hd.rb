module Renalware
  class Configuration
    module HD
      def self.included(base)
        base.config_accessor(:hd_acuity_assessment_deletion_window) do
          ActiveSupport::Duration.parse(
            ENV.fetch("HD_ACUITY_ASSESSMENT_DELETION_WINDOW", "PT12H")
          )
        end

        base.config_accessor(:hd_acuity_assessment_edit_window) do
          ActiveSupport::Duration.parse(
            ENV.fetch("HD_ACUITY_ASSESSMENT_EDIT_WINDOW", "PT12H")
          )
        end

        base.config_accessor(:hd_session_prescriptions_require_signoff) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("HD_SESSION_PRESCRIPTIONS_REQUIRE_SIGNOFF", "true")
          )
        end

        base.config_accessor(:hd_session_require_patient_group_directions) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("HD_SESSION_REQUIRE_PATIENT_GROUP_DIRECTIONS", "false")
          )
        end

        # How many days ahead to look for prescriptions having a future prescribed_on date when
        # determining which 'give on hd' prescriptions to show on the HD session form. Could be
        # eg 10 if session forms are printed on a Friday for the following week.
        base.config_accessor(:hd_session_form_prescription_days_lookahead) do
          ActiveModel::Type::Integer.new.cast(
            ENV.fetch("HD_SESSION_FORM_PRESCRIPTION_DAYS_LOOKAHEAD", 10)
          ) || 10
        end

        base.config_accessor(:hd_max_session_forms_to_print_in_a_batch) do
          ActiveModel::Type::Integer.new.cast(
            ENV.fetch("HD_MAX_SESSION_FORMS_TO_PRINT_IN_A_BATCH", 50)
          )
        end
      end
    end
  end
end
