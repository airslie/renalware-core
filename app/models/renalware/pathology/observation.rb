require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Observation < ActiveRecord::Base
      belongs_to :request, class_name: "ObservationRequest"
      belongs_to :description, class_name: "ObservationDescription"

      validates :description, presence: true
      validates :result, presence: true
      validates :observed_at, presence: true

      scope :ordered, -> { order(observed_at: :desc) }

      def to_s
        result
      end
    end
  end
end
