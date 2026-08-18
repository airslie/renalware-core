module Renalware
  module Patients
    module ODS
      module DSE
        class RowCountPolicy
          API_LOG_IDENTIFIER = "nhs_ods_dse".freeze
          SOURCE_ROW_PREFIX = "source_rows_".freeze
          SOURCE_ROW_PATTERN = /\Asource_rows_(\w+)=(\d+)\z/
          MAXIMUM_DECREASE = 0.15

          def minimum_for(type, fixed_minimum:)
            previous_count = previous_counts[type]
            return fixed_minimum unless previous_count

            relative_minimum = (previous_count * (1 - MAXIMUM_DECREASE)).ceil
            [fixed_minimum, relative_minimum].max
          end

          private

          def previous_counts
            @previous_counts ||= parse_previous_counts
          end

          def parse_previous_counts
            Array(previous_values).filter_map do |value|
              match = value.match(SOURCE_ROW_PATTERN)
              [match[1].to_sym, match[2].to_i] if match
            end.to_h
          end

          def previous_values
            System::APILog
              .where(identifier: API_LOG_IDENTIFIER, status: System::APILog::STATUS_DONE)
              .where(dry_run: false)
              .order(created_at: :desc)
              .pick(:values)
          end
        end
      end
    end
  end
end
