module Renalware
  class PatientPolicy < ApplicationPolicy
    def new? ; has_privilege? end
    def create? ; has_privilege? end
    def edit? ; has_privilege? end
    def update? ; has_privilege? end
    def death_update? ; has_privilege? end
    def index? ; true end
    def demographics? ; true end
    def clinical_summary? ; true end
    def esrf_info? ; true end
    def manage_medications? ; true end
    def pd_info? ; true end
    def problems? ; true end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end
  end
end