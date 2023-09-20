# frozen_string_literal: true

require "rails_helper"

describe "Managing a patient's modalities", js: false do
  let(:patient) { create(:patient) }
  let(:tx_mod_desc) { create(:modality_description, :transplant) }
  let(:hd_mod_desc) { create(:modality_description, :hd) }
  let(:pd_mod_desc) { create(:modality_description, :pd) }

  def change_patient_modality(patient, modality_description, user, started_on: Time.zone.now)
    result = Renalware::Modalities::ChangePatientModality
      .new(patient: patient, user: user)
      .call(description: modality_description, started_on: started_on)
    expect(result).to be_success
    patient.reload
    result.object
  end

  pending "adding a modality"
  pending "editing a modality"

  describe "deleting a modality" do
    context "when there is only one modality" do
      it "user is left with no modality" do
        user = login_as_admin
        modality = change_patient_modality(patient, hd_mod_desc, user)
        visit patient_modalities_path(patient)

        within("#modalities_modality_#{modality.id}") do
          expect {
            click_on "Delete"
          }.to change(Renalware::Modalities::Modality, :count).by(-1)
        end
      end
    end

    context "when deleting the current modality and there is preceding one" do
      it "the preceding one becomes the current modality" do
        user = login_as_admin
        _tx_modality = change_patient_modality(patient, tx_mod_desc, user, started_on: "2021-01-01")
        pd_modality = change_patient_modality(patient, pd_mod_desc, user, started_on: "2022-01-01")
        hd_modality = change_patient_modality(patient, hd_mod_desc, user, started_on: "2023-01-01")
        visit patient_modalities_path(patient)

        expect(patient.reload.current_modality).to eq(hd_modality)
        expect(hd_modality.reload.state).to eq("current")
        expect(pd_modality.reload.state).to eq("terminated")

        within("#modalities_modality_#{hd_modality.id}") do
          expect {
            click_on "Delete"
          }.to change(Renalware::Modalities::Modality, :count).by(-1)
        end

        expect(patient.reload.current_modality).to be_present
        expect(patient.reload.current_modality).to have_attributes(
          description_id: pd_mod_desc.id,
          started_on: Date.parse("2022-01-01"),
          state: "current",
          ended_on: nil
        )
      end
    end
    # expect(page).not_to have_css(".medication-review", wait: 0)

    # accept_alert do
    #   click_on "Medication Review"
    # end

    # expect(page).to have_css(".medication-review")
    # NB: content tests handed in LatestReviewComponent specs
  end
end
