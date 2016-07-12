require_dependency "renalware/modalities"

module Renalware
  module Modalities
    class Reason < ActiveRecord::Base
      def self.policy_class
        BasePolicy
      end
    end
  end
end
