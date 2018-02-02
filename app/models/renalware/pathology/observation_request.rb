require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequest < ApplicationRecord
      has_many :observations,
               foreign_key: :request_id,
               inverse_of: :request,
               dependent: :destroy
      belongs_to :description, class_name: "RequestDescription"
      belongs_to :patient, class_name: "Patient", touch: true

      accepts_nested_attributes_for :observations

      validates :patient, presence: true
      validates :requestor_name, presence: true
      validates :requested_at, presence: true

      scope :ordered, -> { order(requested_at: :desc) }
      scope :having_observations_with_a_loinc_code, lambda {
        joins(observations: :description).where("loinc_code is not null") # TODO: use a merge
      }

      def requested_on
        requested_at.to_date
      end
    end
  end
end
