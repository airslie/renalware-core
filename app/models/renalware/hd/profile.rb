# frozen_string_literal: true

require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class Profile < ApplicationRecord
      include Document::Base
      include PatientScope
      include Accountable
      include Supersedeable

      belongs_to :patient, touch: true
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :dialysate
      belongs_to :prescriber, class_name: "User"
      belongs_to :transport_decider, class_name: "User"
      belongs_to :schedule_definition
      has_document class_name: "Renalware::HD::ProfileDocument"

      has_paper_trail(
        versions: { class_name: "Renalware::HD::Version" },
        on: [:create, :update, :destroy]
      )

      validates :patient, presence: true
      validates :prescriber, presence: true

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      scope :ordered, -> { order(deactivated_at: :desc) }
      scope :dialysing_at_unit, ->(unit_id) { where(hospital_unit_id: unit_id) }

      def self.policy_class
        BasePolicy
      end
    end
  end
end
