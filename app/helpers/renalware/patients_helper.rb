module Renalware
  module PatientsHelper
    def med_color_tag(med_type)
      med_type.blank? ? "drug" : med_type
    end

    def display_pd_menu?(patient)
      patient_modalities = patient.modalities.with_deleted
      patient_modalities.map { |m|m.description.pd_modality? }.include? true
    end

    def display_hd_menu?(patient)
      patient_modalities = patient.modalities.with_deleted
      patient_modalities.map { |m|m.description.hd_modality? }.include? true
    end

    def find_user_bookmark_for_patient(patient)
      user = Renalware::Patients.cast_user(current_user)
      user.bookmark_for_patient(patient)
    end
  end
end
