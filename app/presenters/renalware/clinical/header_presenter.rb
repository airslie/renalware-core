require_dependency "renalware"
require "attr_extras"

module Renalware
  module Clinical
    # In theory the view behind this presenter could be cached using
    # pathology_current_observation_set.updated_at +
    # clinical_current_observation_set.updated_at as the key.
    class HeaderPresenter
      pattr_initialize :patient

      def latest_pathology
        @pathology ||= pathology_current_observation_set.values
      end

      private

      def pathology_current_observation_set
        pathology_patient.current_observation_set || Pathology::NullObservationSet.new
      end

      def pathology_patient
        Pathology.cast_patient(patient)
      end
    end
  end
end
