module Renalware
  module Patients
    module ODS
      module DSE
        class ReportSetDownloader
          def initialize(downloader:, reports:, row_count_policy:)
            @downloader = downloader
            @reports = reports
            @row_count_policy = row_count_policy
          end

          def call(downloaded_files)
            reports.to_h do |type, options|
              file = downloader.call(options.fetch(:name))
              downloaded_files[type] = file
              [type, validate(file, type, options)]
            end
          end

          private

          attr_reader :downloader, :reports, :row_count_policy

          def validate(file, type, options)
            ReportValidator.new(
              path: file.path,
              report_name: options.fetch(:name),
              expected_columns: options.fetch(:columns),
              minimum_rows: row_count_policy.minimum_for(
                type,
                fixed_minimum: options.fetch(:minimum_rows)
              )
            ).call
          end
        end
      end
    end
  end
end
