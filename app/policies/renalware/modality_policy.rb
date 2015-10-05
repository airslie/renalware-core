module Renalware
  class ModalityPolicy < ApplicationPolicy
    def new? ; has_privilege? end
    def create? ; has_privilege? end
    def index? ; true end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end
  end
end
