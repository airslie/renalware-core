# frozen_string_literal: true

require "roo"

module Renalware
  module Heroic
    module BioBank
      class UsageSheet
        pattr_initialize :sheet

        COLUMN_TO_JSON_MAP = {
          sample_type: "Derivative Type/SampleType",
          aliquot_isbt: "ISBT aliquot 15Digits",
          patient_identifier: "Subject ID",
          used_at: "Used on",
          study_name: "Study name",
          notes: "Notes"
        }.freeze

        def self.required_column_headers
          COLUMN_TO_JSON_MAP.values
        end

        def sample_types
          rows_to_be_imported.pluck(:sample_type).uniq.compact
        end

        def patient_identifiers
          rows_to_be_imported.pluck(:patient_identifier).uniq.compact
        end

        def rows_to_be_imported
          @rows_to_be_imported ||= sheet.parse(COLUMN_TO_JSON_MAP)
        end
      end
    end
  end
end
