require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Description < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true, uniqueness: true

      def to_s
        name
      end

      def to_sym
        nil
      end

      def self.policy_class
        Modalities::DescriptionPolicy
      end
    end
  end
end
