# frozen_string_literal: true

require_dependency "renalware/problems"

module Renalware
  module Problems
    class Note < ApplicationRecord
      include Accountable

      belongs_to :problem, touch: true

      scope :ordered, -> { order(created_at: :asc) }

      validates :description, presence: true

      def self.policy_class
        BasePolicy
      end
    end
  end
end
