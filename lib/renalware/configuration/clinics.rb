module Renalware
  class Configuration
    module Clinics
      def self.included(base)
        base.config_accessor(:new_clinic_visit_deletion_window) { 24.hours }
        base.config_accessor(:new_clinic_visit_edit_window) { 7.days }
        base.config_accessor(:clinic_name_code_separator) do
          ENV.fetch("CLINIC_NAME_CODE_SEPARATOR", " ")
        end
      end
    end
  end
end
