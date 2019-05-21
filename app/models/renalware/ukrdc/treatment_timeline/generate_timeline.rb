# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"

module Renalware
  module UKRDC
    module TreatmentTimeline
      class GenerateTimeline
        pattr_initialize :patient

        def call
          modalities.each do |modality|
            case modality.description
            when Renalware::HD::ModalityDescription then GenerateHDTimeline.new(modality).call
            when Renalware::PD::ModalityDescription then GeneratePDTimeline.new(modality).call
            else raise "unrecognised modality class #{modality.description.class}"
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
