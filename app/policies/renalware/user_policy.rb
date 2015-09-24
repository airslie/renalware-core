module Renalware

  class UserPolicy < ApplicationPolicy
    def index?  ; has_privilege? end
    def create? ; has_privilege? end
    def update? ; has_privilege? end

    private
    def has_privilege?
      user.has_role?(:super_admin)
    end

  end
end