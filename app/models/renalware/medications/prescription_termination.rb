require_dependency "renalware/medications"

module Renalware
  module Medications
    class PrescriptionTermination < ActiveRecord::Base
      include Accountable

      belongs_to :prescription

      validates :terminated_on, presence: true
    end
  end
end
