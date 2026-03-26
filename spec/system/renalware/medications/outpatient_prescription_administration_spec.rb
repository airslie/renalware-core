RSpec.describe "Administering drugs from the medications page as an outpatient", :js do
  let(:patient) { create(:patient) }

  def create_prescription_for(patient, drug_name: "Drug1")
    create(
      :prescription,
      patient:,
      give_as_outpatient: true,
      drug: create(:drug, name: drug_name)
    )
  end

  it "records a not-administered outpatient prescription with a reason" do
    prescription = create_prescription_for(patient)
    reason = create(:outpatient_prescription_administration_reason, name: "Patient refused")
    dialog = Pages::Medications::OutpatientPrescriptionAdministrationDialog.new(
      prescription:
    )
    user = login_as_clinical

    dialog.open_by_clicking_on_drug_name
    expect(dialog).to be_visible

    dialog.administered = false
    dialog.recorded_on = "12-Apr-2020"
    dialog.not_administered_reason = reason.name
    dialog.notes = "abc"

    expect(dialog.save_button_captions).to eq(["Sign-off"])
    dialog.save

    administration = patient.outpatient_prescription_administrations.reload.last
    expect(administration).to have_attributes(
      administered: false,
      reason:,
      prescription:,
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

  it "supports saving and witnessing later" do
    password = "renalware"
    nurse = create(:user, password:)
    prescription = create_prescription_for(patient)
    dialog = Pages::Medications::OutpatientPrescriptionAdministrationDialog.new(prescription:)
    user = login_as_clinical

    dialog.open_by_clicking_on_drug_name
    expect(dialog).to be_visible

    dialog.administered = true
    dialog.notes = "abc"
    dialog.administered_by = nurse
    dialog.administered_by_password = password

    expect(dialog.save_button_captions).to eq(["Sign-off", "Save and Witness Later"])
    dialog.save_and_witness_later

    administration = patient.outpatient_prescription_administrations.reload.first
    expect(administration).to have_attributes(
      administered: true,
      prescription:,
      notes: "abc",
      created_by_id: user.id,
      updated_by_id: user.id,
      administered_by: nurse,
      witnessed_by: nil,
      administrator_authorised: true,
      witness_authorised: false
    )
  end

  it "supports full sign-off when witness credentials are supplied" do
    password = "renalware"
    nurse = create(:user, password:)
    witness = create(:user, password:)
    prescription = create_prescription_for(patient)
    dialog = Pages::Medications::OutpatientPrescriptionAdministrationDialog.new(prescription:)

    login_as_clinical

    dialog.open_by_clicking_on_drug_name
    expect(dialog).to be_visible
    expect(dialog).to be_displaying_prescription

    dialog.administered = true
    dialog.notes = "abc"
    dialog.administered_by = nurse
    dialog.administered_by_password = password
    dialog.witnessed_by = witness
    dialog.witnessed_by_password = password
    dialog.save

    administration = patient.outpatient_prescription_administrations.reload.first
    expect(administration).to have_attributes(
      administered: true,
      prescription:,
      notes: "abc",
      administered_by: nurse,
      witnessed_by: witness,
      administrator_authorised: true,
      witness_authorised: true
    )
  end
end
