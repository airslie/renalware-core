require "renalware/letters/part"

module Renalware
  module Letters
    class Part::RecentPathologyResults < DumbDelegator
      def initialize(patient, service: nil)
        @patient = patient

        service ||= default_service(patient)
        super(service.call)
      end

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      private

      def default_service(patient)
        presenter = Pathology::CurrentObservationResults::Presenter.new
        descriptions = Letters::RelevantObservationDescription.all
        Pathology::ViewCurrentObservationResults.new(patient, presenter, descriptions: descriptions)
      end
    end
  end
end
