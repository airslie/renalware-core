require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CurrentObservationResultsController < Pathology::BaseController
      def index
        patient = load_patient
        observation_set = ObservationSetPresenter.new(
          patient.fetch_current_observation_set
        )
        render :index, locals: { observation_set: observation_set }
      end
    end
  end
end
