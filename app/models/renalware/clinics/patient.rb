module Renalware
  module Clinics
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :clinic_visits, class_name: "Clinics::ClinicVisit"
    end
  end
end
