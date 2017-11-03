require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Consult < ApplicationRecord
      include Accountable
      extend Enumerize
      acts_as_paranoid
      validates :patient_id, presence: true
      validates :hospital_unit_id, presence: true
      validates :hospital_ward_id, presence: true
      validates :started_on, presence: true
      validates :description, presence: true

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"

      enumerize :transfer_priority, in: %i(unknown necessary desirable potential unnecessary)
      enumerize :aki_risk, in: %i(yes no unknown)
    end
  end
end
