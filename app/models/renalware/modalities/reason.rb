require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Reason < ActiveRecord::Base
      self.table_name = "modality_reasons"

      def self.policy_class
        BasePolicy
      end
    end
  end
end
