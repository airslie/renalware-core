# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class DashboardsController < BaseController
      def show
        authorize [:renalware, :virology, :dashboard], :show?
        render locals: {
          patient: patient,
          vaccinations: Vaccination.for_patient(patient)
        }
      end
    end
  end
end
