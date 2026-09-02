module Renalware
  module Heidi
    class SessionPolicy < BasePolicy
      def index? = user_is_any_admin?
    end
  end
end
