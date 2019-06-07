# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

# rubocop:disable Rails/Output
module Renalware
  module UKRDC
    module TreatmentTimeline
      #
      # Re-generates the ukrdc_treatments for a patient from their modalities and other information.
      #
      class GenerateTimeline
        pattr_initialize :patient

        def call
          PrepareTables.call
          RemapModelTableNamesToTheirPreparedEquivalents.call

          modalities.each do |modality|
            print "#{modality.description.name} "
            GeneratorFactory.call(modality).call
          end
        end

        private

        def modalities
          patient.modalities.order(started_on: :asc, updated_at: :asc)
        end
      end
    end
  end
end
# rubocop:enable Rails/Output
