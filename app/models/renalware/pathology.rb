# frozen_string_literal: true

module Renalware
  module Pathology
    module_function

    def table_name_prefix = "pathology_"

    def cast_patient(patient)
      ActiveType.cast(
        patient,
        ::Renalware::Pathology::Patient,
        force: Renalware.config.force_cast_active_types
      )
    end

    class MissingRequestDescriptionError < StandardError; end

    class MissingObservationDescriptionError < StandardError; end
  end
end
