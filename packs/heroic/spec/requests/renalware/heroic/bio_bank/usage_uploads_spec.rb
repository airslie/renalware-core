# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic::BioBank
  RSpec.describe "Biobank usgaes upload from Excel spreadsheet" do
    let(:user) { @current_user }
    let(:patient) { create(:patient, local_patient_id_5: "HEROIC_RFH_001") }
    let(:serum_sample_type) { create(:serum_sample_type) }
    let(:epla_sample_type) { create(:epla_sample_type) }

    def xls_fixture_file_upload(filename)
      fixture_file_upload(
        file_fixture("biobank/uploads/#{filename}.xlsx"),
        "application/xls"
      )
    end

    before do
      patient
      serum_sample_type
      epla_sample_type
      create(:heroic_research_study)
    end

    describe "POST create" do
      context "with valid inputs" do
        it "processes the upload" do
          params = {
            upload: {
              file: xls_fixture_file_upload(:usages_test)
            }
          }

          expect {
            post(heroic.bio_bank_usage_uploads_path, params: params)
          }.to change(Upload, :count).by(1)

          expect(response).to be_redirect
          follow_redirect!
          expect(response).to be_successful

          upload = Upload.last
          expect(upload.staged_changes).not_to be_nil
          expect(upload.status).to eq("previewing")
          expect(upload.file).not_to be_nil
        end
      end
    end

    describe "PUT update" do
      context "with valid inputs" do
        it "processes the upload" do
          patient
          upload = create(:bio_bank_usage_upload)
          sample = create(
            :bio_bank_sample,
            sample_type: serum_sample_type,
            by: user,
            patient: patient
          )
          aliquot1 = create(
            :bio_bank_aliquot,
            isbt: upload.staged_changes[0]["aliquot_isbt"],
            sample: sample,
            by: user
          )
          aliquot2 = create(
            :bio_bank_aliquot,
            isbt: upload.staged_changes[1]["aliquot_isbt"],
            sample: sample,
            by: user
          )

          params = {
            upload: {
              status: "commited"
            }
          }

          put(heroic.bio_bank_usage_upload_path(upload), params: params)

          expect(response).to be_redirect
          follow_redirect!
          expect(response).to be_successful

          upload = Upload.last
          expect(upload.status).to eq("changes_committed")
          expect(upload.usages.count).to eq(2)

          staged_change = upload.staged_changes.first
          expect(Usage).to exist(
            usable_id: aliquot1.id,
            used_at: Time.zone.parse(staged_change["used_at"]),
            study_name: staged_change["study_name"],
            notes: staged_change["notes"]
          )

          staged_change = upload.staged_changes.last
          expect(Usage).to exist(
            usable_id: aliquot2.id,
            used_at: Time.zone.parse(staged_change["used_at"]),
            study_name: staged_change["study_name"],
            notes: staged_change["notes"]
          )
        end
      end
    end
  end
end
