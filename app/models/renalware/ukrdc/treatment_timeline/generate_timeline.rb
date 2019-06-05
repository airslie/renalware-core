# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

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
            case modality.description
            when Renalware::HD::ModalityDescription then GenerateHDTimeline.new(modality).call
            when Renalware::PD::ModalityDescription then GeneratePDTimeline.new(modality).call
              # else raise "unrecognised modality class #{modality.description.class}"
            end
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
