# frozen_string_literal: true

require_dependency "renalware/deaths"

module Renalware
  module Deaths
    class Location < ApplicationRecord
      validates :name, presence: true, uniqueness: { case_sensitive: false }
      acts_as_paranoid
      before_validation { self.name = name&.strip }
      scope :ordered, -> { order(:name) }

      def to_s
        name
      end

      def self.policy_class
        BasePolicy
      end
    end
  end
end