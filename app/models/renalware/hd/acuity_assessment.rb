module Renalware
  module HD
    class AcuityAssessment < ApplicationRecord
      include Accountable
      include PatientScope

      belongs_to :patient, class_name: "Renalware::Patient"

      validates :patient_id, presence: true
      validates :ratio, presence: true

      scope :ordered, -> { order(created_at: :desc) }
    end
  end
end
