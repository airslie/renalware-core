# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionTermination < ApplicationRecord
      include Accountable

      belongs_to :prescription, touch: true

      validates :terminated_on,
                timeliness: {
                  type: :date,
                  on_or_after: ->(record) { record.prescription.prescribed_on }
                }
    end
  end
end
