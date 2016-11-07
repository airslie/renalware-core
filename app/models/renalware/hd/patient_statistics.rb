require_dependency "renalware/hd"

module Renalware
  module HD
    class PatientStatistics < ActiveRecord::Base
      include PatientScope

      belongs_to :patient
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"

      validates :hospital_unit, presence: true
      validates :patient,
                presence: true,
                uniqueness: { scope: [:month, :year] }

      validates :month,
                numericality: true,
                inclusion: 1..12,
                allow_nil: true

      validates :month, presence: true, unless: :rolling?
      validates :year, presence: true, unless: :rolling?

      validates :year,
                numericality: true,
                inclusion: 1970..2100,
                allow_nil: true

      validates :rolling,
                inclusion: { in: [true, nil] }
    end
  end
end
