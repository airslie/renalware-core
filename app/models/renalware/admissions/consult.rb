require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Consult < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :patient_id, presence: true
      validates :hospital_unit_id, presence: true
      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
    end
  end
end
