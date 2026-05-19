# frozen_string_literal: true

require "attr_extras"
require "roo"

module Renalware
  module Heroic
    module BioBank
      class CreateUsagesFromUpload
        pattr_initialize :upload, :by

        def call
          ActiveRecord::Base.transaction do
            upload.staged_changes.each do |row|
              patient = find_patient(row)
              aliquot = find_aliquot(row)
              raise "Aliquot does not belong to patient" unless aliquot.sample.patient == patient

              create_usage(aliquot, row)
            end
            upload.update!(status: :changes_committed, by: by)
          end
        end

        private

        def create_usage(aliquot, row)
          usage = aliquot.usage || aliquot.build_usage
          usage.study_name = row["study_name"]
          usage.notes = row["notes"]
          usage.used_at = row["used_at"]
          usage.upload_id = upload.id
          usage.save_by!(by)
          usage
        end

        # Find the first patient matching the identifier in an local_patient column
        def find_patient(row)
          PatientQuery.new(row["patient_identifier"]).call
        end

        def find_aliquot(row)
          Aliquot.find_by!(isbt: row["aliquot_isbt"])
        end
      end
    end
  end
end
