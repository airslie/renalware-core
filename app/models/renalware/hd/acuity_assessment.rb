module Renalware
  module HD
    class AcuityAssessment < ApplicationRecord
      include Accountable
      include PatientScope

      enum :ratio, {
        "1:4" => "1:4",
        "1:3" => "1:3",
        "1:2" => "1:2",
        "1:1" => "1:1"
      }

      belongs_to :patient, class_name: "Renalware::Patient"

      validates :patient_id, presence: true
      validates :ratio, presence: true

      scope :ordered, -> { order(created_at: :desc) }
    end
  end
end
