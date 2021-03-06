# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    class Dialyser < ApplicationRecord
      acts_as_paranoid

      validates :group, presence: true
      validates :name, presence: true
      validates :membrane_surface_area, numericality: true, allow_blank: true
      validates :membrane_surface_area_coefficient_k0a, numericality: true, allow_blank: true

      scope :ordered, -> { order(:group, :name) }

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
