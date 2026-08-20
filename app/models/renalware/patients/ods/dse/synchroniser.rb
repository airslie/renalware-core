module Renalware
  module Patients
    module ODS
      module DSE
        class Synchroniser
          REPORTS = {
            practices: {
              name: "epraccur",
              columns: 27,
              minimum_rows: 10_000,
              importer: Feeds::Files::Practices::ImportCSV
            },
            primary_care_physicians: {
              name: "egpcur",
              columns: 27,
              minimum_rows: 50_000,
              importer: Feeds::Files::PrimaryCarePhysicians::ImportCSV
            },
            practice_memberships: {
              name: "epracmem",
              columns: 6,
              minimum_rows: 50_000,
              importer: Feeds::Files::PracticeMemberships::ImportCSV
            }
          }.freeze
          TOTAL_COUNT_KEYS = %i(practices primary_care_physicians practice_memberships).freeze
          API_LOG_IDENTIFIER = RowCountPolicy::API_LOG_IDENTIFIER
          SOURCE_ROW_PREFIX = RowCountPolicy::SOURCE_ROW_PREFIX

          def initialize(
            dry_run: false,
            downloader: Downloader.new,
            reports: REPORTS,
            row_count_policy: RowCountPolicy.new
          )
            @dry_run = dry_run
            @downloader = downloader
            @reports = reports
            @row_count_policy = row_count_policy
          end

          def call
            downloaded_files = {}
            result = nil

            System::APILog.with_log(API_LOG_IDENTIFIER, dry_run:) do |api_log|
              report_downloader = ReportSetDownloader.new(downloader:, reports:, row_count_policy:)
              row_counts = report_downloader.call(downloaded_files)
              result = synchronise(downloaded_files, row_counts)
              update_api_log(api_log, result)
              log_result(result)
            end

            result
          ensure
            downloaded_files&.each_value(&:close!)
          end

          private

          attr_reader :dry_run, :downloader, :reports, :row_count_policy

          def synchronise(downloaded_files, row_counts)
            result = nil
            before = snapshot

            ActiveRecord::Base.transaction do
              import_reports(downloaded_files)
              result = { before:, after: snapshot, row_counts: }
              raise ActiveRecord::Rollback if dry_run
            end

            result
          end

          def import_reports(downloaded_files)
            reports.each do |type, options|
              path = Pathname(downloaded_files.fetch(type).path)
              options.fetch(:importer).new(path).call
            end
          end

          def snapshot
            {
              practices: Patients::Practice.count,
              active_practices: Patients::Practice.where(active: true).count,
              primary_care_physicians: Patients::PrimaryCarePhysician.unscoped.count,
              active_primary_care_physicians: Patients::PrimaryCarePhysician.count,
              practice_memberships: Patients::PracticeMembership.unscoped.count,
              active_practice_memberships: Patients::PracticeMembership.where(active: true).count
            }
          end

          def update_api_log(api_log, result)
            additions = TOTAL_COUNT_KEYS.sum do |key|
              [result.dig(:after, key) - result.dig(:before, key), 0].max
            end

            api_log.update!(
              pages: reports.size,
              records_added: additions,
              values: result.fetch(:row_counts).map do |key, value|
                "#{SOURCE_ROW_PREFIX}#{key}=#{value}"
              end + result.fetch(:after).map { |key, value| "#{key}=#{value}" }
            )
          end

          def log_result(result)
            Rails.logger.info(
              "ODS DSE sync#{' dry run' if dry_run}: " \
              "rows=#{result.fetch(:row_counts).inspect} " \
              "before=#{result.fetch(:before).inspect} after=#{result.fetch(:after).inspect}"
            )
          end
        end
      end
    end
  end
end
