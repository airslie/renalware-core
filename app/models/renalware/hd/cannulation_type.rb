# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class CannulationType < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
