require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionTermination < ApplicationRecord
      include Accountable

      belongs_to :prescription

      validates :terminated_on,
        timeliness: { type: :date, after: ->(record) { record.prescription.prescribed_on } }
    end
  end
end
