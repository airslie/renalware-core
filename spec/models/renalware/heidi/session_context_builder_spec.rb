describe Renalware::Heidi::SessionContextBuilder do
  subject(:context) { described_class.new(patient).call }

  let(:patient) { create(:patient, :minimal) }

  it "builds clinician notes from active patient problems and current prescriptions" do
    create(
      :problem,
      patient:,
      description: "Diabetes mellitus",
      snomed_id: "73211009",
      date: Date.new(2001, 2, 3)
    )
    create(
      :problem,
      patient:,
      description: "Hypertension",
      snomed_id: nil,
      date: nil
    )
    create(:drug_frequency, name: "daily", title: "Daily")
    prescription = create(
      :prescription,
      patient:,
      drug: create(:drug, name: "Amlodipine"),
      dose_amount: "5"
    )

    expect(context).to include(
      clinician_notes: [
        "Renalware patient problems:",
        "- Diabetes mellitus; SNOMED: 73211009; Date: 2001-02-03",
        "- Hypertension",
        "Renalware current prescriptions:",
        "- #{Renalware::Medications::PrescriptionPresenter.new(prescription)}"
      ]
    )
  end

  it "builds session patient details from Renalware demographics" do
    patient.update_columns(
      given_name: "John",
      family_name: "Smith",
      born_on: Date.new(1980, 5, 15),
      sex: "M",
      secure_id: "a4556f64-0efd-4d91-8ce4-5390ac345c76"
    )

    expect(context).to include(
      patient: {
        name: "John Smith",
        gender: "MALE",
        dob: "1980-05-15",
        demographic_details: "John Smith, M, 1980-05-15"
      },
      ehr_patient_id: "a4556f64-0efd-4d91-8ce4-5390ac345c76"
    )
  end

  it "omits archived problems" do
    create(:problem, patient:, description: "Current problem")
    create(:problem, patient:, description: "Archived problem", deleted_at: 1.day.ago)

    expect(context.fetch(:clinician_notes)).to contain_exactly(
      "Renalware patient problems:",
      "- Current problem"
    )
  end

  it "omits terminated prescriptions" do
    current_prescription = create(:prescription, patient:, drug: create(:drug, name: "Amlodipine"))
    terminated_prescription = create(:prescription, patient:, drug: create(:drug, name: "Ramipril"))
    create(:prescription_termination, prescription: terminated_prescription)

    expect(context.fetch(:clinician_notes)).to contain_exactly(
      "Renalware current prescriptions:",
      "- #{Renalware::Medications::PrescriptionPresenter.new(current_prescription)}"
    )
  end

  it "returns patient context when the patient has no active problems or current prescriptions" do
    expect(context).to include(:patient, :ehr_patient_id)
    expect(context).not_to have_key(:clinician_notes)
  end
end
