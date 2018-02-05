require_dependency "renalware/virology"
require_dependency "renalware/events"

module Renalware
  module Virology
    class Vaccination < Events::Event
      # Return e.g. "renalware/virology/vaccinations/toggled_cell
      def partial_for(partial_type)
        File.join("renalware/virology/vaccinations", partial_type)
      end
    end
  end
end
