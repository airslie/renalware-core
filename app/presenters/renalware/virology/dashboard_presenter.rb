# frozen_string_literal: true

require_dependency "renalware/virology"

module Renalware
  module Virology
    class DashboardPresenter
      include PresenterHelper

      attr_reader_initialize :patient

      def latest_hep_b_antibody_statuses
        @latest_hep_b_antibody_statuses ||= begin
          Renalware::Pathology::CreateObservationsGroupedByDateTable.new(
            patient: patient,
            observation_descriptions: Renalware::Pathology::ObservationDescription.for(Array("BHBS")),
            page: 1,
            per_page: 5
          ).call
        end
      end

      def latest_hep_b_antibody_statuses?
        latest_hep_b_antibody_statuses.rows.any?
      end

      def vaccinations
        Vaccination.for_patient(patient)
      end
    end
  end
end
