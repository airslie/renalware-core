module Renalware
  module PD
    class AdequacyResultPolicy < BasePolicy
      def destroy?
        user_is_admin? || user_is_super_admin?
      end
    end
  end
end
