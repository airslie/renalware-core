require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CurrentObservation < ApplicationRecord
      belongs_to :patient, class_name: "Renalware::Pathology::Patient"
    end
  end
end
