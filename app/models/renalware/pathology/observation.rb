require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Observation < ActiveRecord::Base
      belongs_to :request, class_name: "ObservationRequest"
      belongs_to :description, class_name: "ObservationDescription"

      validates :request, presence: true
      validates :description, presence: true
      validates :result, presence: true
      validates :observed_at, presence: true
    end
  end
end
