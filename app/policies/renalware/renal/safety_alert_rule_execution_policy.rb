module Renalware
  module Renal
    class SafetyAlertRuleExecutionPolicy < BasePolicy
      def index? = user_is_super_admin?

      def show? = false
      def update? = false
      alias edit? update?
      alias create? update?
      alias destroy? update?
    end
  end
end
