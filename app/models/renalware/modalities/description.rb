require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Description < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end

      def to_sym
        nil
      end
    end
  end
end
