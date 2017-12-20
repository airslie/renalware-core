require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Inpatient < ApplicationRecord
      include Accountable
      extend Enumerize
      acts_as_paranoid
      validates :patient_id, presence: true
      validates :hospital_unit_id, presence: true
      validates :hospital_ward_id, presence: true
      validates :admitted_on, presence: true
      validates :reason_for_admission, presence: true
      validates :admission_type, presence: true

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      belongs_to :summarised_by, class_name: "User"

      enumerize :admission_type, in: %i(unknown routine elective emergency consult transfer)
      enumerize :discharge_destination, in: %i(home other_ward other_hosp itu death other)
    end
  end
end
