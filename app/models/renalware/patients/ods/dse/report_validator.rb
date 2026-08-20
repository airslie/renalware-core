require "csv"

module Renalware
  module Patients
    module ODS
      module DSE
        class ReportValidator
          def initialize(path:, report_name:, expected_columns:, minimum_rows:)
            @path = path
            @report_name = report_name
            @expected_columns = expected_columns
            @minimum_rows = minimum_rows
          end

          def call
            row_count = 0

            CSV.foreach(path, headers: false) do |row|
              row_count += 1
              validate_row!(row, row_count)
            end

            validate_row_count!(row_count)
            row_count
          rescue CSV::MalformedCSVError => e
            raise ValidationError, "ODS DSE report #{report_name} is malformed: #{e.message}"
          end

          private

          attr_reader :path, :report_name, :expected_columns, :minimum_rows

          def validate_row!(row, row_number)
            return if row.length == expected_columns

            raise ValidationError,
                  "ODS DSE report #{report_name} row #{row_number} has #{row.length} columns; " \
                  "expected #{expected_columns}"
          end

          def validate_row_count!(row_count)
            return if row_count >= minimum_rows

            raise ValidationError,
                  "ODS DSE report #{report_name} has only #{row_count} rows; " \
                  "expected at least #{minimum_rows}"
          end
        end
      end
    end
  end
end
