# frozen_string_literal: true

require "document/base"

module Renalware
  module Clinical
    class DryWeight < ApplicationRecord
      include PatientScope
      include Accountable

      belongs_to :patient, class_name: "Renalware::Clinical::Patient", touch: true
      belongs_to :assessor, class_name: "User"

      has_paper_trail(
        versions: { class_name: "Renalware::Clinical::Version" },
        on: [:create, :update, :destroy]
      )

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :weight, presence: true, "renalware/patients/weight" => true
      validates :assessed_on, presence: true
      validates :assessed_on, timeliness: { type: :date, allow_blank: false }

      def self.policy_class
        BasePolicy
      end

      def self.latest
        ordered.first
      end
    end
  end
end
