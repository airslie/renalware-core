require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Code < ActiveRecord::Base
      self.table_name = "modality_codes"
      acts_as_paranoid

      has_many :modalities
      has_many :patients, through: :modalities

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
