require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Observation < ApplicationRecord
      belongs_to :request, class_name: "ObservationRequest", touch: true, inverse_of: :observations
      belongs_to :description, class_name: "ObservationDescription"

      validates :description, presence: true
      validates :result, presence: true
      validates :observed_at, presence: true

      scope :ordered, -> { order(observed_at: :desc) }
      scope :for_description, ->(description) { where(description: description) }

      def observed_on
        observed_at.to_date
      end

      delegate :to_s, to: :result
    end
  end
end
