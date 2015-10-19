module Renalware
  class DrugPolicy < BasePolicy

    def selected_drugs? ; has_privilege? end

    private
    def has_privilege?
      user.has_role?(:clinician) || user.has_role?(:admin) || user.has_role?(:super_admin)
    end

  end
end