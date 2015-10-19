module Renalware
  class DrugPolicy < BasePolicy

    def selected_drugs? ; has_write_privileges? end

  end
end