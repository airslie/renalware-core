module Renalware
  class BaseLetterPolicy < ApplicationPolicy
    def index? ; has_privilege? end
    def author? ; has_privilege? end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end
  end
end
