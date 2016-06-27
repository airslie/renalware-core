require "renalware/letters/part"

module Renalware
  module Letters
    class Part::RecentPathologyResults < Part

      delegate :each, :present?, to: :recent_pathology_results

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      private

      def recent_pathology_results
        @recent_pathology_results ||= find_recent_pathology_results
      end

      def find_recent_pathology_results
        presenter = Pathology::CurrentObservationResults::Presenter.new
        descriptions = Letters::RelevantObservationDescription.all
        results = Pathology::CurrentObservationsForDescriptionsQuery
          .new(patient: @patient, descriptions: descriptions)
          .call
        # Removes the header from the results, this will be unnecessary when
        # a custom Presenter is implemented
        presenter.present(results)[1..-1]
      end
    end
  end
end
