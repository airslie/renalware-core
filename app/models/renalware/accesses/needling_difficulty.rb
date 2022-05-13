# frozen_string_literal: true

require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class NeedlingDifficulty < ApplicationRecord
      include Accountable
      belongs_to :patient, class_name: "Renalware::Accesses::Patient"
      validates :difficulty, presence: true
      validates :patient, presence: true
      enum difficulty_type: { easy: "easy", moderate: "moderate", hard: "hard" }

      scope :ordered, -> { order(created_at: :desc) }

      def self.latest
        ordered.first
      end

      def self.policy_class
        BasePolicy
      end
    end
  end
end
