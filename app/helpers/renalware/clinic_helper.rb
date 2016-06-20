module Renalware
  module ClinicHelper
    def link_to_create_or_edit_clinic_visit_letter(patient, clinic_visit)
      visit = Letters.cast_clinic_visit(clinic_visit)
      if visit.letter.present?
        link_to 'Preview Letter', patient_letters_letter_path(patient, visit.letter)
      else
        link_to 'Create Letter', new_patient_letters_letter_path(@patient, clinic_visit_id: visit.id)
      end
    end
  end
end
