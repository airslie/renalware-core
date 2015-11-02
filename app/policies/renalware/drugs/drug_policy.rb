require_dependency 'renalware/drugs'

module Renalware
  module Drugs
    class DrugPolicy < BasePolicy

      def selected_drugs? ; has_write_privileges? end

    end
  end
end
