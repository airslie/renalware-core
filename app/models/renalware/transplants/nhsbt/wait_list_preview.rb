module Renalware
  module Transplants
    module NHSBT
      class WaitListPreview
        def initialize(rows)
          @rows = rows
        end

        def call
          rows.map { |row| preview_row_for(row) }.sort_by { |row| sort_key(row) }
        end

        private

        attr_reader :rows

        def preview_row_for(row)
          registration = find_registration(row)
          patient = registration&.patient

          source_attributes(row)
            .merge(patient_attributes(registration, patient))
            .stringify_keys
        end

        def source_attributes(row)
          {
            recip_id: row.recip_id,
            date_of_birth: row.date_of_birth.iso8601,
            kidney_status: row.kidney_status,
            kidney_status_date: row.kidney_status_date.iso8601,
            tissue_type: row.tissue_type,
            crf: row.crf,
            sensi_eval_date: row.sensi_eval_date.iso8601,
            imported: false
          }.merge(match_attributes(row), waiting_time_attributes(row))
        end

        def match_attributes(row)
          {
            match_score: row.match_score,
            match_points: row.match_points
          }
        end

        def waiting_time_attributes(row)
          {
            kidney_waiting_time_days: row.kidney_waiting_time_days,
            pancreas_waiting_time_days: row.pancreas_waiting_time_days
          }
        end

        def patient_attributes(registration, patient)
          {
            matched: registration.present?,
            registration_id: registration&.id,
            patient_id: patient&.id,
            patient_secure_id: patient&.secure_id,
            patient_name: patient&.to_s,
            patient_family_name: patient&.family_name,
            patient_given_name: patient&.given_name,
            patient_nhs_number: patient&.nhs_number,
            current_status: registration&.document&.uk_transplant_centre&.status
          }
        end

        def find_registration(row)
          Registration
            .includes(:patient)
            .joins(:patient)
            .where(
              "transplant_registrations.document -> 'codes' ->> " \
              "'uk_transplant_patient_recipient_number' = ?",
              row.recip_id
            )
            .where(patients: { born_on: row.date_of_birth })
            .first
        end

        def sort_key(row)
          [
            row["matched"] ? 1 : 0,
            row["patient_family_name"].to_s.downcase,
            row["patient_given_name"].to_s.downcase,
            row["recip_id"].to_s
          ]
        end
      end
    end
  end
end
