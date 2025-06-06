module Renalware
  module Patients
    class WorryCategoryPolicy < BasePolicy
      def index?
        user_is_any_admin?
      end
      alias show? index?

      def new?
        user_is_super_admin?
      end
      alias create? new?

      def edit?
        return false unless record.persisted?
        return false if record.deleted?

        user_is_super_admin?
      end
      alias update? edit?
      alias destroy? edit?
    end
  end
end
