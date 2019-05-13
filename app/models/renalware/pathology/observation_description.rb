# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescription < ApplicationRecord
      has_many :observations,
               class_name: "Pathology::Observation",
               inverse_of: :description,
               dependent: :restrict_with_exception
      belongs_to :measurement_unit
      has_many(
        :group_memberships,
        class_name: "ObservationGroupMembership",
        foreign_key: :description_id,
        dependent: :destroy
      )
      has_many(
        :groups,
        through: :group_memberships,
        class_name: "ObservationGroup"
      )

      scope :in_display_order, lambda {
        where("display_group is not null and display_order is not null")
        .order([:display_group, :display_order])
      }

      def self.for(codes)
        ObservationDescriptionsByCodeQuery.new(codes: codes).call
      end

      def to_s
        code
      end
    end
  end
end
