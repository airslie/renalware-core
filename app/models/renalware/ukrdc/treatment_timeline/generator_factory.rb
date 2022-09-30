# frozen_string_literal: true

require "benchmark"

module Renalware
  module UKRDC
    module TreatmentTimeline
      class GeneratorFactory
        DEFAULT_TYPE = "Generic"

        # Each modality_description has a :code fiekd
        def self.call(modality)
          type = modality.description.code&.to_s&.camelize
          klass = (klass_for(type) || klass_for(DEFAULT_TYPE)).new(modality)
          Rails.logger.debug { "GeneratorFactory type = #{type} class = #{klass}" }
          klass
        end

        def self.klass_for(type)
          "Renalware::UKRDC::TreatmentTimeline::#{type}::Generator".safe_constantize
        end
      end
    end
  end
end
