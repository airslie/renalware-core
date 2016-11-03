require_dependency "renalware/hd"

module Renalware
  module HD
    class PatientStatistics < ActiveRecord::Base
      include PatientScope

      belongs_to :patient
      belongs_to :hospital_unit

      validates :hospital_unit, presence: true
      validates :patient,
                presence: true,
                uniqueness: { scope: [:month, :year] }

      # month = 0 = rolling (last 12 months rolled up)
      validates :month,
                numericality: true,
                inclusion: 0..12,
                allow_nil: true

      # year = 0 = rolling (last 12 months rolled up)
      validates :year,
                numericality: true,
                inclusion: 0..2100
    end
  end
end
