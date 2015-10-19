module Renalware
  class PatientPolicy < BasePolicy
    def death_update? ; has_privilege? end
    def death? ; true end
    def esrf_info? ; true end
    def show? ; true end
    def manage_medications? ; true end
    def problems? ; true end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end
  end
end
