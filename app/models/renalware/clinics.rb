# frozen_string_literal: true

module Renalware
  module Clinics
    def self.table_name_prefix = "clinic_"
    def self.cast_patient(patient) = patient.becomes(Clinics::Patient)
  end
end
