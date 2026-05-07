# frozen_string_literal: true

require "roo"
require "attr_extras"

module Renalware
  module Heroic
    module BioBank
      class SamplesSheet
        pattr_initialize :sheet

        COLUMN_TO_JSON_MAP = {
          sample_type: "Derivative Type/SampleType",
          isbt: "ISBT",
          aliquot_isbt: "ISBT aliquot 15Digits",
          location: "Current Location",
          patient_identifier: "Subject ID",
          collected_at: "Sample Collection Date",
          processed_at: "Processing Date"
        }.freeze

        def rows_to_be_imported
          all_samples.reject do |row|
            all_sample_isbt.include?(row[:isbt]) && all_aliquot_isbt.include?(row[:aliquot_isbt])
          end
        end

        def all_samples
          @all_samples ||= sheet.parse(COLUMN_TO_JSON_MAP)
        end

        def self.required_column_headers
          COLUMN_TO_JSON_MAP.values
        end

        def sample_types
          all_samples.pluck(:sample_type).uniq.compact
        end

        def patient_identifiers
          all_samples.pluck(:patient_identifier).uniq.compact
        end

        private

        def all_aliquot_isbt
          @all_aliquot_isbt ||= Aliquot.pluck(:isbt)
        end

        def all_sample_isbt
          @all_sample_isbt ||= Sample.pluck(:isbt)
        end
      end
    end
  end
end
