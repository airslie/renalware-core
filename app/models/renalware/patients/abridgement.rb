# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class Abridgement < ApplicationRecord
      self.table_name = "patient_master_index"
      validates :hospital_number, presence: true
      validates :given_name, presence: true
      validates :family_name, presence: true
    end
  end
end
