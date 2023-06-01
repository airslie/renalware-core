# frozen_string_literal: true

module Renalware
  module Clinical
    class IganRisk < ApplicationRecord
      belongs_to :patient, touch: true
      validates :patient, presence: true
      validates :risk,
                presence: true,
                numericality: {
                  allow_nil: true,
                  in: 0.00..100.00
                }

      def self.policy_class
        BasePolicy
      end
    end
  end
end
