module Renalware
  module PatientsHelper
    def med_color_tag(med_type)
      med_type.blank? ? "drug" : med_type
    end
  end
end
