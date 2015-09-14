module Renalware
  module UsersHelper

    def current_user_is_super_admin?
      current_user.has_role?(:super_admin)
    end

    def current_user_is_admin?
      current_user.has_role?(:admin) || current_user_is_super_admin?
    end
  end
end