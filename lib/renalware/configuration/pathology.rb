module Renalware
  class Configuration
    module Pathology
      def self.included(base)
        base.config_accessor(:process_hl7_via_raw_messages_table) do
          ENV.fetch("PROCESS_HL7_VIA_RAW_MESSAGES_TABLE", "false") == "true"
        end

        base.config_accessor(:replay_historical_pathology_when_new_patient_added) do
          ActiveModel::Type::Boolean.new.cast(
            ENV.fetch("REPLAY_HISTORICAL_PATHOLOGY_WHEN_NEW_PATIENT_ADDED", "true")
          )
        end

        base.config_accessor(:pathology_hep_b_antibody_status_obx_code) do
          ENV.fetch("PATHOLOGY_HEP_B_ANTIBODY_STATUS_OBX_CODE", "BHBS")
        end

        base.config_accessor(:pathology_post_hd_urea_code) { "P_URE" }

        base.config_accessor(:pathology_hours_to_search_behind_for_pre_ure_result) do
          ENV.fetch("PATHOLOGY_HOURS_TO_SEARCH_BEHIND_FOR_PRE_URE_RESULT", "6").to_i
        end

        base.config_accessor(:pathology_hours_to_search_ahead_for_pre_ure_result) do
          ENV.fetch("PATHOLOGY_HOURS_TO_SEARCH_AHEAD_FOR_PRE_URE_RESULT", "4").to_i
        end

        base.config_accessor(:pathology_acr_obx_code_for_kfre_calculation) do
          ENV.fetch("PATHOLOGY_ACR_OBX_CODE_FOR_KFRE_CALCULATION", "ACR")
        end

        base.config_accessor(:pathology_kfre_2y_obx_code) { "KFRE2" }
        base.config_accessor(:pathology_kfre_5y_obx_code) { "KFRE5" }
        base.config_accessor(:pathology_kfre_obr_code) { "KFRE" }
      end
    end
  end
end
