module Renalware
  module Renal
    class SafetyAlertRulePolicy < BasePolicy
      def index? = user_is_super_admin?
      def enable? = user_is_super_admin?
      def disable? = user_is_super_admin?
      def run? = user_is_super_admin?

      def update? = false
      alias edit? update?
      alias create? update?
      alias destroy? update?
    end
  end
end
