require "rails_helper"

module Renalware
  module Transplants
    describe "NHSBT wait list uploads" do
      it "shows upload progress on the upload page" do
        login_as_admin

        get new_transplants_nhsbt_wait_list_upload_path

        expect(response.body).to include("Upload")
        expect(response.body).to include("Preview")
        expect(response.body).to include("Review")
        expect(response.body).to include("aria-current=\"step\"")
      end

      it "previews a CSV file" do
        user = login_as_admin
        registration = create_matching_registration
        post_upload
        upload = NHSBTWaitListUpload.last

        expect(response).to redirect_to(transplants_nhsbt_wait_list_upload_path(upload))
        expect(upload.created_by).to eq(user)
        expect(upload.filename).to eq("nhsbt_wait_list_status.csv")
        expect(upload.matched_count).to eq(1)
        expect(upload.unmatched_count).to eq(1)

        follow_redirect!

        expect(response.body).to include("NHSBT Wait List Preview")
        expect(response.body).to include("ACTIVE - ROUTINE")
        expect(response.body).to include("SUSPENDED")
        expect(response.body).to include("aria-current=\"step\"")
        expect(response.body)
          .to include(patient_transplants_registration_path(registration.patient))
      end

      it "imports matched rows from a previewed upload", :aggregate_failures do
        login_as_admin
        registration = create_matching_registration
        post_upload
        upload = NHSBTWaitListUpload.last
        patch import_transplants_nhsbt_wait_list_upload_path(upload)

        expect(response).to redirect_to(transplants_nhsbt_wait_list_upload_path(upload))
        follow_redirect!
        expect(response.body).to include("Review")
        expect(response.body).to include("aria-current=\"step\"")

        imported_registration = Registration.find(registration.id)
        expect(imported_registration.document.uk_transplant_centre.status).to eq("ACTIVE - ROUTINE")
        expect(imported_registration.document.uk_transplant_centre.status_updated_on)
          .to eq(Date.parse("2024-01-12"))
        expect(imported_registration.document.hla.type).to eq("A2 B15 B75")
        expect(imported_registration.match_score).to eq(93)
        expect(imported_registration.match_points).to eq(8)
        expect(imported_registration.kidney_waiting_time_days).to eq(776)
        expect(imported_registration.pancreas_waiting_time_days).to be_nil
        expect(imported_registration.document.crf.latest.result).to eq("50")
        expect(imported_registration.document.crf.latest.recorded_on)
          .to eq(Date.parse("2023-07-25"))
        expect(upload.reload.imported_count).to eq(1)
      end

      def create_matching_registration
        patient = create(
          :transplant_patient,
          family_name: "Smith",
          given_name: "Sam",
          born_on: Date.parse("1977-04-25")
        )
        create(:transplant_registration, patient:).tap do |registration|
          registration.document.codes.uk_transplant_patient_recipient_number = "1234"
          registration.document.uk_transplant_centre.status = "OLD STATUS"
          registration.save!
        end
      end

      def post_upload
        post transplants_nhsbt_wait_list_uploads_path,
             params: {
               transplants_nhsbt_wait_list_upload_form: {
                 file: fixture_file_upload(
                   file_fixture("nhsbt_wait_list_status.csv"),
                   "text/csv"
                 )
               }
             }
      end
    end
  end
end
