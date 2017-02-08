module Renalware
  module PathologyHelper
    def current_pathology_for(patient)
      Pathology::CurrentObservationsForDescriptionsQuery
        .new(patient: patient, descriptions: Pathology::RelevantObservationDescription.all)
        .call
    end
  end
end
