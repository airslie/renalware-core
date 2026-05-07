# frozen_string_literal: true

require "attr_extras"
require "roo"

module Renalware
  module Heroic
    module BioBank
      class CreateSamplesFromUpload
        pattr_initialize :upload, :by

        def call
          ActiveRecord::Base.transaction do
            upload.staged_changes.each do |row|
              sample = find_or_initialize_sample(row)
              find_or_initialize_aliquot(sample, row)
              sample.save_by!(by)
            end
            upload.update!(status: :changes_committed, by: by)
          end
        end

        private

        # Find the first patient matching the identifier in an local_patient column
        def find_patient(identifier)
          PatientQuery.new(identifier).call
        end

        def find_or_initialize_sample(row)
          Sample.create_with(
            storage_location: row["location"],
            processed_at: row["processed_at"],
            collected_at: row["collected_at"],
            received_at: Time.zone.now,
            sample_type: SampleType.find_by!(abbreviation: row["sample_type"]),
            upload_id: upload.id
          ).find_or_initialize_by(
            isbt: row["isbt"],
            patient: find_patient(row["patient_identifier"])
          )
        end

        def find_or_initialize_aliquot(sample, row)
          sample.aliquots.create_with(
            updated_by_id: by.id,
            created_by_id: by.id,
            upload_id: upload.id
          ).find_or_initialize_by(
            isbt: row["aliquot_isbt"]
          )
        end
      end
    end
  end
end
