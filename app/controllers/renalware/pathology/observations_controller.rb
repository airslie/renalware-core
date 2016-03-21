require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsController < Pathology::BaseController
      before_filter :load_patient

      def index
        query = Renalware::Pathology::ArchivedResultsQuery.new(patient: @patient).call
        observation_descriptions = Renalware::Pathology::ObservationDescription.limit(10)
        presenter = Renalware::Pathology::ArchivedResultsPresenter.new(
          query, observation_descriptions
        )

        render :index, locals: { results: presenter, observation_descriptions: observation_descriptions }
      end
    end
  end
end
