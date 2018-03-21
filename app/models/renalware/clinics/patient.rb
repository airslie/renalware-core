# frozen_string_literal: true

module Renalware
  module Clinics
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :clinic_visits, class_name: "Clinics::ClinicVisit"
      has_many :appointments, class_name: "Clinics::Appointment"
    end
  end
end
