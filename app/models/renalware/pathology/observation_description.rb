# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescription < ApplicationRecord
      belongs_to :measurement_unit
      has_many :observations,
               class_name: "Pathology::Observation",
               inverse_of: :description,
               dependent: :restrict_with_exception
      has_many :code_group_memberships, dependent: :destroy
      has_many :code_groups, through: :code_group_memberships

      scope :in_display_order, lambda {
        where("display_group is not null and display_order is not null")
        .order([:display_group, :display_order])
      }

      enum rr_type: { rr_type_simple: 0, rr_type_interpretation: 1 }
      enum rr_coding_standard: { ukrr: 0, pv: 1 }

      def self.for(codes)
        ObservationDescriptionsByCodeQuery.new(codes: codes).call
      end

      def to_s
        code
      end
    end
  end
end
