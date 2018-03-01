require_dependency "renalware/feeds"

module Renalware
  module Feeds
    module Files
      module Practices
        class ImportJob < ApplicationJob
          include StringLogging
          include Feeds::Job
          FILE_TO_EXTRACT_FROM_ARCHIVE = /HSCOrgRefData_Full_/

          # Initialize with the absolute path to an fullfile.zip file
          # e.g. /Users/tim/Downloads/hscorgrefdataxml_data_1.0.1_20170526000001.zip
          # downloaded from
          # https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/341/releases
          #
          # Example usage:
          #   # Download and unzip hscorgrefdataxml_data_1.0.1_000001.zip and grab the fullfile.zip
          #   Practices::Import.new("/Users/tim/Downloads/fullfile.zip")

          # Arguments:
          #   file - a Feeds::File object previously persisted.
          def perform(file)
            logging_to_stringio(strio = StringIO.new) # so we can write the error to the File model
            file.update!(status: :processing, attempts: file.attempts + 1)
            status = :success
            elapsed_ms = Benchmark.ms do
              process_archive(file.location)
            end
          rescue StandardError => e
            Rails.logger.error(formatted_exception(e))
            status = :failure
            raise e
          ensure
            file.update!(status: status, result: strio.string, time_taken: elapsed_ms)
          end

          private

          def process_archive(zipfile)
            log "Practice count before update: #{practice_count}"
            log "Opening #{zipfile}"
            ZipArchive.new(zipfile).unzip do |files|
              xml_pathname = find_file_in(files, FILE_TO_EXTRACT_FROM_ARCHIVE)
              csv_path = Practices::ConvertXmlToCsv.call(xml_pathname)
              FileUtils.copy(csv_path, Rails.root.join("generated_organisations.csv"))
              Practices::ImportCSV.new(csv_path).call
            end
            log "Practice count after update: #{practice_count}"
          end

          def practice_count
            Renalware::Patients::Practice.count
          end
        end
      end
    end
  end
end
