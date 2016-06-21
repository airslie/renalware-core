module Renalware
  module ClinicHelper
    def link_to_clinic_visit_letter(patient, clinic_visit)
      visit = Letters.cast_clinic_visit(clinic_visit)
      if visit.letter.present?
        link_to "Preview Letter", patient_letters_letter_path(patient, visit.letter)
      else
        path = new_patient_letters_letter_path(
          @patient,
          event_type: clinic_visit.class.name.to_s, event_id: clinic_visit.id
        )
        link_to "Draft Letter", path
      end
    end
  end
end
