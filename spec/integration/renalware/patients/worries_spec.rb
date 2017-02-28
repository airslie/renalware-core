require "rails_helper"

RSpec.describe "Managing the patient worryboard", type: :request do
  let(:patient) { create(:patient) }

  describe "POST create" do
    context "the patient has no worry (!)" do
      it "creates a new patient worry (aka adding them to the Worryboard)" do
        post(patient_worry_path(patient))
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:success)

        expect(Renalware::Patients::Worry.find_by(patient_id: patient.id)).to_not be_nil
      end
    end

    context "the patient already has a worry (i.e. is on the worryboard)" do
      it "behaves idempotently, does not fail, behaves as if the patient was just added" do
        Renalware::Patients::Worry.new(patient: patient, by: @current_user).save!

        post(patient_worry_path(patient))
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:success)

        expect(Renalware::Patients::Worry.find_by(patient_id: patient.id)).to_not be_nil
      end
    end

    describe "DELETE destroy" do

      it "soft deletes the bookmark" do
        worry = Renalware::Patients::Worry.new(patient: patient, by: @current_user)
        worry.save!

        delete patient_worry_path(patient, worry)

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patients::Worry.exists?(id: worry.id)).to be_falsey
      end

      it "does not baulk if the bookmark does not exist" do
        delete patient_worry_path(patient, id: 999)
        expect(response).to have_http_status(:redirect)
      end

      with_versioning do
        it "stores a papertrail version with the correct whodunnit value" do
          expect(PaperTrail).to be_enabled
          worry = Renalware::Patients::Worry.new(patient: patient, by: @current_user)
          worry.save!

          delete patient_worry_path(patient, worry)

          expect(response).to have_http_status(:redirect)
          version = Renalware::Patients::Version.last
          expect(version.whodunnit.to_s).to eq(@current_user.id.to_s)
        end
      end
    end
  end
end
