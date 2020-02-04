# frozen_string_literal: true

require "rails_helper"

# rubocop:disable all
describe "Administering drugs from HD Dashboard, independent of HD Session", type: :system, js: true do
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
      let(:patient) { create(:hd_patient) }
      let(:prescription) { create_prescription_for patient }
      NO_WITNESS = false
      WITNESS = true
      ADMINISTERED = true
      UNADMINSTRED = false
      NOTES = "notes"
      SUCCESS = true
      FAILURE = false
      NO_WITNESS_PWD = ""
      NO_ADMIN_PWD = ""
      ERR_MISSING_ADMINISTERED = ".hd_prescription_administration_administered .error"
      ERR_MISSING_ADMIN_PWD = ".hd_prescription_administration_administered_by_password .error"
      ERR_MISSING_WITNESS = ".hd_prescription_administration_witnessed_by .error"
      ERR_MISSING_WITNESS_PWD = ".hd_prescription_administration_witnessed_by_password .error"
      PWD = "supersecret"

      # [ false,      -> { nurse },  "",              nil,      "",                "x",    false, [] ]

      # administered | nurse_pwd | witness | witness_pwd | notes | success | errors
      # -----------------------------------------------------------------------------------------------------------
      NULLS = {
        administered: nil, admin_pwd: "", witness: nil, witness_pwd: "", notes: "", success: false, errs: []
      }
      {
        administered_radio_unset: NULLS.merge(administered: nil, errs: ERR_MISSING_ADMINISTERED),
        not_administered_ok: NULLS.merge(administered: false, success: true),
        administered_missing_admin_pwd: NULLS.merge(administered: true, errs: [ERR_MISSING_ADMIN_PWD, ERR_MISSING_WITNESS]),
        administered_missing_witness_user: NULLS.merge(administered: true, admin_pwd: PWD, errs: [ERR_MISSING_WITNESS])
      }
      {
        missing_administered: [
          nil,    NO_ADMIN_PWD,  NO_WITNESS, NO_WITNESS_PWD, NOTES, FAILURE, [ERR_MISSING_ADMINISTERED]
        ],
        not_administered: [
          UNADMINSTRED,  NO_ADMIN_PWD,  NO_WITNESS,  NO_WITNESS_PWD,  NOTES,     SUCCESS,  [] ],
        administered_missing_admin_pwd: [
          ADMINISTERED,  NO_ADMIN_PWD,  NO_WITNESS,  NO_WITNESS_PWD,  NOTES,  FAILURE,  [ERR_MISSING_ADMIN_PWD, ERR_MISSING_WITNESS]
        ],
        administered_missing_witness_user: [
          ADMINISTERED,  NO_ADMIN_PWD,  NO_WITNESS,  NO_WITNESS_PWD,  NOTES,  FAILURE,  [ERR_MISSING_WITNESS]
        ],
        administered_missing_witness_pwd: [
          ADMINISTERED, "supersecret", WITNESS, NO_WITNESS_PWD, NOTES, FAILURE, [ERR_MISSING_WITNESS_PWD]
        ]
      }.each do |name, (administered, nurse_pwd, witness, witness_pwd, notes, success, errors)|
        it name do
          dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
          witnessed_by = create(:user) if witness
          current_user = login_as_clinical

          dialog.open_by_clicking_on_drug_name
          dialog.administered = administered
          dialog.witnessed_by = witnessed_by
          dialog.notes = notes
          dialog.save

          if success
            expect(page).not_to have_css(dialog.container_css)
            expect(Renalware::HD::PrescriptionAdministration.last).to have_attributes(
              administered: administered,
              notes: notes,
              witnessed_by: witnessed_by,
              witness_authorised: witnessed_by.present?
            )
            # administrator_authorised: true,
            #administered_by: current_user,
          else
            expect(page).to have_css(dialog.container_css) # still visible
            Array(errors).each do |error_css|
              expect(page).to have_css(error_css)
            end
          end
        end
      end
      # it "displays a modal dialog asking for input, which I can cancel" do
      #   prescription = create_prescription_for patient
      #   dialog = Pages::HD::PrescriptionAdministrationDialog.new(prescription: prescription)
      #   login_as_clinical

      #   dialog.open_by_clicking_on_drug_name
      #   expect(dialog).to be_visible
      #   expect(dialog).to be_displaying_prescription
      #   dialog.cancel
      #   expect(dialog).not_to be_visible
      # end
    end
  end
end
# rubocop:enable all
