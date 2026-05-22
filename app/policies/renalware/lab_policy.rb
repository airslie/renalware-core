module Renalware
  class LabPolicy < BasePolicy
    def show?
      user.feature_flags.allbits?(FeatureFlags::LAB)
    end
  end
end
