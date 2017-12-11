require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CurrentObservationSet < ApplicationRecord
      belongs_to :patient, class_name: "Renalware::Pathology::Patient"
      validates :patient, presence: true
    end
  end
end
