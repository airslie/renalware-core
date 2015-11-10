require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Description < ActiveRecord::Base
      self.table_name = "modality_descriptions"
      acts_as_paranoid

      validates :name, presence: true
      validates :code, presence: true

      PD_NAMES = ["PD-APD", "PD-CAPD", "PD Rest on HD", "PD-Assisted APD", "PD-PrePD"]

      def self.policy_class
        BasePolicy
      end

      def death?
        name == "Death"
      end

      def pd_modality?
        PD_NAMES.include?(name)
      end

    end
  end
end
