require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Observation < ActiveRecord::Base
      belongs_to :request, class_name: "ObservationRequest"
      belongs_to :description, class_name: "ObservationDescription"
    end
  end
end
