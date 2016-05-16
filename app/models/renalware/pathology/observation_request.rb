require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequest < ActiveRecord::Base
      has_many :observations, foreign_key: :request_id
      belongs_to :description, class_name: "RequestDescription"
      belongs_to :patient, class_name: "Patient"

      accepts_nested_attributes_for :observations

      validates :patient, presence: true
      validates :requestor_name, presence: true
      validates :requested_at, presence: true

      scope :ordered, -> { order(requested_at: :desc) }

      def requested_on
        requested_at.to_date
      end
    end
  end
end
