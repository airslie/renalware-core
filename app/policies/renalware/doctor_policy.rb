module Renalware
  class DoctorPolicy < ApplicationPolicy
    def index? ; true end
    def new? ; has_privilege? end
    def create? ; has_privilege? end
    def edit? ; has_privilege? end
    def update? ; has_privilege? end
    def destroy? ; has_privilege? end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end
  end
end