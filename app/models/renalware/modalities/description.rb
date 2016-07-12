require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Description < ActiveRecord::Base
      self.table_name = "modality_descriptions"
      acts_as_paranoid

      validates :name, presence: true

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
