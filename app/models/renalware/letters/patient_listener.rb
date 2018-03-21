# frozen_string_literal: true

module Renalware
  module Letters
    class PatientListener
      def patient_modality_changed_to_death(patient:, modality:, actor:)
        # Using update_columns here (bypassing validation) because currently, once the Death
        # modality is assigned, attempting to update the patient triggers validation
        # on cause_of_death which will at this stage be missing.
        patient.update_columns(
          cc_on_all_letters: false,
          cc_decision_on: modality.started_on
        )
      end
    end
  end
end
