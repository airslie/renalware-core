module Renalware
  module PatientsHelper
    def med_color_tag(med_type)
      med_type.blank? ? "drug" : med_type
    end

    def display_pd_menu(patient_modalities)
      patient_modalities.map { |m|m.description.pd_modality? }.include? true
    end

  end
end
