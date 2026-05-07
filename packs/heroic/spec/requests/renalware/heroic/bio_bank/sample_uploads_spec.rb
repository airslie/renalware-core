# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic::BioBank
  RSpec.describe "Biobank samples upload from Excel spreadsheet" do
    let(:user) { @current_user }
    let(:patient) { create(:patient, local_patient_id_5: "HEROIC_RFH_001") }
    let(:serum_sample_type) { create(:serum_sample_type) }

    def xls_fixture_file_upload(filename)
      fixture_file_upload(
        file_fixture("biobank/uploads/#{filename}.xlsx"),
        "application/xls"
      )
    end

    before do
      patient
      serum_sample_type
      create(:heroic_research_study)
      create(:epla_sample_type)
    end

    describe "POST create" do
      context "with valid inputs" do
        it "processes the upload" do
          params = {
            upload: {
              file: xls_fixture_file_upload(:samples_test)
            }
          }

          expect {
            post(heroic.bio_bank_sample_uploads_path, params: params)
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
          upload = create(:bio_bank_upload)

          params = {
            upload: {
              status: "commited"
            }
          }

          put(heroic.bio_bank_sample_upload_path(upload), params: params)

          expect(response).to be_redirect
          follow_redirect!
          expect(response).to be_successful

          upload = Upload.last
          expect(upload.status).to eq("changes_committed")

          expect(upload.samples.count).to eq(1)
          expect(upload.aliquots.reload.count).to eq(1)
          sample = upload.samples.first
          # There is just one staged change defined in the fatcory
          staged_change = upload.staged_changes.first
          expect(sample).to have_attributes(
            isbt: staged_change["isbt"],
            storage_location: staged_change["location"],
            processed_at: Time.zone.parse(staged_change["processed_at"]),
            collected_at: Time.zone.parse(staged_change["collected_at"]),
            sample_type_id: serum_sample_type.id,
            patient_id: patient.id
          )
        end
      end
    end
  end
end
