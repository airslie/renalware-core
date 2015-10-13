module Renalware
  class ModalityReason < ActiveRecord::Base
    has_many :modalities

    def self.policy_class
      BasePolicy
    end
  end
end