# frozen_string_literal: true

require_dependency "renalware/ukrdc"
require "attr_extras"
require "benchmark"

module Renalware
  module UKRDC
    module TreatmentTimeline
      class GeneratorFactory
        DEFAULT_TYPE = "Generic"

        # Returns the class of object to suitable for generating the treatment timeline for the
        # requested modality. If the modality description type is nil then we use a generic
        # generator. If no generator class is defined matching the description.type, we also
        # return nil.
        # Example:
        # given the modality_description.type of Renalware::Bla::BlaModalityDescription
        # we will look to see if the constant GenerateBlaBlaTimeline exists and return an instance
        # if so - otherwise we return an instance of the default generator GenerateGenericTimeline.
        def self.call(modality)
          type = modality.description.type.presence || DEFAULT_TYPE
          type = type.gsub("::", "").gsub(/^Renalware/, "").gsub(/ModalityDescription$/, "")
          (klass_for(type) || klass_for(DEFAULT_TYPE)).new(modality)
        end

        def self.klass_for(type)
          "Renalware::UKRDC::TreatmentTimeline::Generators::#{type}Timeline".safe_constantize
        end
      end
    end
  end
end
