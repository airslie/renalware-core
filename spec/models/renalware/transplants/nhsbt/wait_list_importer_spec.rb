require "rails_helper"

module Renalware
  module Transplants
    module NHSBT
      describe WaitListImporter do
        let(:user) { create(:user) }
        let(:patient) { create(:transplant_patient, family_name: "Smith", given_name: "Sam") }
        let(:registration) { create(:transplant_registration, patient:) }

        it "updates matched registration status and NHSBT metadata" do
          registration.document.codes.uk_transplant_patient_recipient_number = "1234"
          registration.document.uk_transplant_centre.status = "OLD STATUS"
          registration.save!

          upload = create(
            :transplant_nhsbt_wait_list_upload,
            by: user,
            filename: "wait-list.csv",
            matched_count: 1,
            unmatched_count: 1,
            rows: upload_rows
          )

          described_class.new(upload:, by: user).call

          imported_registration = Registration.find(registration.id)
          expect(imported_registration.document.uk_transplant_centre.status)
            .to eq("ACTIVE - ROUTINE")
          expect(imported_registration.document.uk_transplant_centre.status_updated_on)
            .to eq(Date.parse("2024-01-12"))
          expect(imported_registration.nhsbt_last_import_source).to eq("wait-list.csv")
          expect(upload.reload).to be_imported
          expect(upload.imported_count).to eq(1)
          expect(upload.rows.pluck("imported")).to eq([false, true])
        end

        it "updates matched registration HLA, match, and CRF data" do
          registration.document.codes.uk_transplant_patient_recipient_number = "1234"
          registration.save!
          upload = create_upload

          described_class.new(upload:, by: user).call

          imported_registration = Registration.find(registration.id)
          expect(imported_registration.document.hla.type).to eq("A2 B15 B75")
          expect(imported_registration.match_score).to eq(93)
          expect(imported_registration.match_points).to eq(8)
          expect(imported_registration.kidney_waiting_time_days).to eq(776)
          expect(imported_registration.pancreas_waiting_time_days).to eq(12)
          expect(imported_registration.document.crf.latest.result).to eq("50")
          expect(imported_registration.document.crf.latest.recorded_on)
            .to eq(Date.parse("2023-07-25"))
        end

        it "does not update CRF when the imported CRF is not positive" do
          registration.document.codes.uk_transplant_patient_recipient_number = "1234"
          registration.document.crf.latest.result = "42"
          registration.document.crf.latest.recorded_on = Date.parse("2023-01-01")
          registration.save!
          upload = create_upload(rows: [matched_row.merge("crf" => "0")])

          described_class.new(upload:, by: user).call

          imported_registration = Registration.find(registration.id)
          expect(imported_registration.document.crf.latest.result).to eq("42")
          expect(imported_registration.document.crf.latest.recorded_on)
            .to eq(Date.parse("2023-01-01"))
        end

        def create_upload(rows: upload_rows)
          create(
            :transplant_nhsbt_wait_list_upload,
            by: user,
            filename: "wait-list.csv",
            matched_count: 1,
            unmatched_count: 1,
            rows:
          )
        end

        def upload_rows
          [
            unmatched_row,
            matched_row
          ]
        end

        def unmatched_row
          {
            "recip_id" => "9999",
            "date_of_birth" => "1977-04-25",
            "kidney_status" => "ACTIVE - ROUTINE",
            "kidney_status_date" => "2024-01-12",
            "matched" => false,
            "imported" => false
          }.merge(extra_import_attributes)
        end

        def extra_import_attributes
          {
            "tissue_type" => "A2 B15 B75",
            "match_score" => "93",
            "match_points" => "8",
            "crf" => "50",
            "sensi_eval_date" => "2023-07-25",
            "kidney_waiting_time_days" => "776",
            "pancreas_waiting_time_days" => "12"
          }
        end

        def matched_row
          unmatched_row.merge(
            "recip_id" => "1234",
            "date_of_birth" => patient.born_on.iso8601,
            "matched" => true,
            "registration_id" => registration.id
          )
        end
      end
    end
  end
end
