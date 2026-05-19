# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Heroic
    module BioBank
      # Validate the uploaded file by loading it as an excel spreadsheet, checking the content is
      # sufficient to process, and if not, populating an errors array the caller can interrogate.
      class ValidateUsageSpreadsheet
        pattr_initialize :file_path, :upload

        def call
          @xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)
          return unless there_are_missing_sheet_headers?

          check_sample_types_exist
          check_patients_exist

          true # indicates no error
        rescue Zip::Error
          errors << "File doesn't seem to be an Excel xslx file"
        end

        def errors
          @errors ||= []
        end

        private

        attr_reader :xlsx

        def there_are_missing_sheet_headers?
          headings = xlsx.sheet(0).row(1)
          required_headings = UsageSheet.required_column_headers
          missing_headings = required_headings - headings
          return true if missing_headings.empty?

          errors << <<~ERR.squish
            Sheet2 column headings not found: #{missing_headings.join(', ')}.
            Sheet2 should contain these column headings: #{required_headings.join(', ')}.
          ERR
        end

        def sheet
          @sheet ||= UsageSheet.new(xlsx.sheet(0))
        end

        def check_sample_types_exist
          missing_sample_types = sheet.sample_types - possible_sample_types
          missing_sample_types.each { |type| errors << "Sample type #{type} not found" }
        end

        def check_patients_exist
          sheet.patient_identifiers.each do |identifier|
            unless patient_exists?(identifier)
              errors << "Patient #{identifier} not found"
            end
          end
        end

        def possible_sample_types
          @possible_sample_types ||= SampleType.pluck(:abbreviation)
        end

        def patient_exists?(identifier)
          Patient
            .where(<<~SQL.squish, identifier, identifier, identifier, identifier, identifier).exists?
              local_patient_id = ? OR
              local_patient_id_2 = ? OR
              local_patient_id_3 = ? OR
              local_patient_id_4 = ? OR
              local_patient_id_5 = ?
            SQL
        end
      end
    end
  end
end
