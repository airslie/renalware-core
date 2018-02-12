require_dependency "renalware/virology"

module Renalware
  module Virology
    class DashboardsController < BaseController
      def show
        authorize patient
        render locals: {
          patient: patient,
          vaccinations: Vaccination.for_patient(patient)
        }
      end
    end
  end
end
