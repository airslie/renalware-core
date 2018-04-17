# frozen_string_literal: true

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

      # Modalities::Description subclasses can override this to for instance add
      # the patient's 'HD Site' add after 'HD'
      def augmented_name_for(_patient)
        name
      end
    end
  end
end
