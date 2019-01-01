# frozen_string_literal: true

module Renalware
  module HD
    class PatientListener
      def patient_modality_changed_to_death(patient:, modality:, actor:)
        nullify_significant_hd_profile_attributes(patient, by: actor)
      end

      def request_default_electronic_cc_recipients_for_use_in_letters(patient:, array_of_user_ids:)
        patient = HD.cast_patient(patient)
        if patient.current_modality_hd?
          named_nurse_id = patient.hd_profile&.named_nurse&.id
          array_of_user_ids.push(named_nurse_id) if named_nurse_id.present?
        end
      end

      private

      def nullify_significant_hd_profile_attributes(patient, by:)
        hd_profile = HD.cast_patient(patient).hd_profile
        return if hd_profile.nil?

        hd_profile.hospital_unit = nil
        hd_profile.schedule_definition = nil
        hd_profile.save_by!(by)
      end
    end
  end
end
