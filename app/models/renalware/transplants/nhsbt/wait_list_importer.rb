require "digest"

module Renalware
  module Transplants
    module NHSBT
      class WaitListImporter
        def initialize(upload:, by:)
          @upload = upload
          @by = by
        end

        def call
          now = Time.zone.now

          NHSBTWaitListUpload.transaction do
            imported_rows, imported_count = import_rows(now)

            upload.update_by(
              by,
              status: :imported,
              imported_at: now,
              imported_count:,
              rows: imported_rows
            )
          end

          upload
        end

        private

        attr_reader :upload, :by

        def import_rows(imported_at)
          imported_count = 0
          imported_rows = upload.rows.map do |row|
            next row.merge("imported" => false) unless row["matched"]

            import_row(row, imported_at)
            imported_count += 1
            row.merge("imported" => true)
          end

          [imported_rows, imported_count]
        end

        def import_row(row, imported_at)
          registration = Registration.find(row.fetch("registration_id"))
          registration.document = document_attributes_for(registration, row)
          registration.match_score = row.fetch("match_score")
          registration.match_points = row.fetch("match_points")
          registration.kidney_waiting_time_days = row.fetch("kidney_waiting_time_days")
          registration.pancreas_waiting_time_days = row.fetch("pancreas_waiting_time_days")
          registration.nhsbt_last_imported_at = imported_at
          registration.nhsbt_last_import_source = upload.filename
          registration.nhsbt_last_import_checksum = checksum
          registration.save!
        end

        def document_attributes_for(registration, row)
          registration.read_attribute(:document).deep_dup.tap do |document|
            assign_ukt_status(document, row)
            assign_hla(document, row)
            assign_crf(document, row)
          end
        end

        def assign_ukt_status(document, row)
          document["uk_transplant_centre"] ||= {}
          document["uk_transplant_centre"]["status"] = row.fetch("kidney_status")
          document["uk_transplant_centre"]["status_updated_on"] = row.fetch("kidney_status_date")
        end

        def assign_hla(document, row)
          document["hla"] ||= {}
          document["hla"]["type"] = row.fetch("tissue_type")
        end

        def assign_crf(document, row)
          return unless positive_crf?(row)

          document["crf"] ||= {}
          document["crf"]["latest"] ||= {}
          document["crf"]["latest"]["result"] = row.fetch("crf")
          document["crf"]["latest"]["recorded_on"] = row.fetch("sensi_eval_date")
        end

        def positive_crf?(row)
          BigDecimal(row.fetch("crf").to_s).positive?
        rescue ArgumentError
          false
        end

        def checksum
          @checksum ||= Digest::SHA256.hexdigest(upload.rows.to_json)
        end
      end
    end
  end
end
