# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationRequest < ApplicationRecord
      has_many :observations,
               foreign_key: :request_id,
               inverse_of: :request,
               dependent: :destroy
      belongs_to :description, class_name: "RequestDescription", inverse_of: :requests
      belongs_to :patient, class_name: "Patient", touch: true

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
