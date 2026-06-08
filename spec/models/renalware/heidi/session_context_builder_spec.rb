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

    expect(context).to eq(
      clinician_notes: [
        "Renalware patient problems:",
        "- Diabetes mellitus; SNOMED: 73211009; Date: 2001-02-03",
        "- Hypertension",
        "Renalware current prescriptions:",
        "- #{Renalware::Medications::PrescriptionPresenter.new(prescription)}"
      ]
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

  it "returns no context when the patient has no active problems or current prescriptions" do
    expect(context).to eq({})
  end
end
