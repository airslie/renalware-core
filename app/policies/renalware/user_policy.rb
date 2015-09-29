module Renalware

  class UserPolicy < ApplicationPolicy
    def create? ; has_privilege? end
    def edit? ; has_privilege? end
    def index? ; has_privilege? end

    private
    def has_privilege?
      user.has_role?(:super_admin)
    end

  end
end