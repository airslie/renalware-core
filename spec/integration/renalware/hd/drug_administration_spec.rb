# frozen_string_literal: true

require "rails_helper"

describe "Administering drugs from HD Dashboard, independent of HD Session", type: :system do
  include AjaxHelpers
  let(:patient) { create(:hd_patient) }

  def create_prescription_for(patient, drug_name: "Drug1")
    create(
      :prescription,
      patient: patient,
      administer_on_hd: true,
      drug: create(:drug, name: drug_name)
    )
  end

  context "when the patient has a drug to be given on HD", js: true do
    context "when I click on the HD Drugs button and choose the drug" do
      it "displays a modal dialog asking for input, which I can cancel" do
        prescription = create_prescription_for patient
        dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
        login_as_clinical

        dialog.open_by_clicking_on_drug_name
        expect(dialog).to be_visible
        expect(dialog).to be_displaying_prescription
        dialog.cancel
        expect(dialog).not_to be_visible
      end

      context "when I indicate the drug was not given, and supply a reason", js: true do
        it "saves the prescription administration and updates the drugs table" do
          prescription = create_prescription_for patient
          reason = Renalware::HD::PrescriptionAdministrationReason.find_or_create_by!(name: "Cos")
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          user = login_as_clinical
          visit renalware.patient_hd_dashboard_path(patient)

          dialog.open_by_clicking_on_drug_name
          expect(dialog).to be_visible
          dialog.administered = false
          dialog.recorded_on = "12-Apr-2020"
          dialog.not_administered_reason = reason.name
          dialog.notes = "abc"

          # Choosing Administered = No should have changed the save button text to Save
          # and hidden the 'Save and witness later' button
          expect(dialog.save_button_captions).to eq ["Save"]
          dialog.save

          expect(page).not_to have_css(dialog.container_css)

          # A not-administered drug has been recorded
          expect(patient.prescription_administrations.reload.last).to have_attributes(
            administered: false,
            reason: reason,
            prescription: prescription,
            notes: "abc",
            created_by_id: user.id,
            updated_by_id: user.id,
            recorded_on: Date.parse("12-Apr-2020"),
            administered_by: nil,
            witnessed_by: nil,
            administrator_authorised: false,
            witness_authorised: false
          )
        end
      end

      context "when drug WAS given, but user elects to witness later", js: true do
        it "saves the prescription administration and updates the drugs table" do
          password = "renalware"
          nurse = create(:user, password: password)
          prescription = create_prescription_for patient
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          user = login_as_clinical

          dialog.open_by_clicking_on_drug_name
          expect(dialog).to be_visible
          dialog.administered = true
          dialog.notes = "abc"
          dialog.administered_by = nurse
          dialog.administered_by_password = password

          expect(dialog.save_button_captions).to eq(["Save and Witness Later", "Save"])

          dialog.save_and_witness_later

          # dialog gone - need to test this way
          expect(page).not_to have_css(dialog.container_css)

          # An administered drug is recorded
          expect(patient.prescription_administrations.reload.first).to have_attributes(
            administered: true,
            reason: nil,
            prescription: prescription,
            notes: "abc",
            created_by_id: user.id,
            updated_by_id: user.id,
            administered_by: nurse,
            recorded_on: Date.current, # the default dorm value defaults to today
            witnessed_by: nil,
            administrator_authorised: true,
            witness_authorised: false
          )
        end
      end

      context "when drug WAS given, AND witness is present to enter their credentials", js: true do
        it "saves the prescription administration and updates the drugs table" do
          password = "renalware"
          nurse = create(:user, password: password)
          witness = create(:user, password: password)
          prescription = create_prescription_for patient
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          user = login_as_clinical

          dialog.open_by_clicking_on_drug_name

          expect(dialog).to be_visible
          dialog.administered = true
          dialog.notes = "abc"
          dialog.administered_by = nurse
          dialog.administered_by_password = password
          dialog.witnessed_by = witness
          dialog.witnessed_by_password = password

          expect(dialog.save_button_captions).to eq(["Save and Witness Later", "Save"])

          dialog.save

          # dialog gone - need to test this way
          expect(page).not_to have_css(dialog.container_css)

          # An administered drug is recorded
          expect(patient.prescription_administrations.reload.first).to have_attributes(
            administered: true,
            reason: nil,
            prescription: prescription,
            notes: "abc",
            created_by_id: user.id,
            updated_by_id: user.id,
            administered_by: nurse,
            witnessed_by: witness,
            administrator_authorised: true,
            witness_authorised: true
          )
        end
      end
    end
  end

  describe "default nurse" do
    context "when displaying the dialog for recoding an HD prescription was given" do
      it "defaults the Nurse to the currently logged-in user" do
        prescription = create_prescription_for patient
        dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
        user = login_as_clinical

        dialog.open_by_clicking_on_drug_name

        expect(dialog.administered_by_id).to eq(user.id)
      end
    end
  end
end
