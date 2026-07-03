# frozen_string_literal: true

RSpec.describe Renalware::HD::ChangePatientModalityToTransferOutJob do
  include PatientsSpecHelper

  let(:user) { create(:user) }

  before do
    create(:user, :system)
    create(:modality_description, code: "transfer_out")
    allow(Renalware.config)
      .to receive(:hd_session_require_patient_group_directions)
      .and_return(false)
  end

  def create_hd_patient_and_session(
    last_session_date: 32.days.ago,
    hd_modality_start_date: Time.zone.now
  )
    patient = create(:hd_patient, by: user)
    set_modality(
      patient:,
      modality_description: create(:hd_modality_description),
      started_on: hd_modality_start_date,
      by: user
    )
    patient.create_hd_profile!(prescriber: user, by: user, hospital_unit: nil)
    create(:hd_closed_session, patient:, started_at: last_session_date)
    patient
  end

  it "does not create a new modality when current modality started after the transfer date" do
    patient = create_hd_patient_and_session(
      last_session_date: 1.year.ago,
      hd_modality_start_date: 10.days.ago
    )

    expect do
      described_class.perform_now
    end.not_to change(Renalware::Modalities::Modality, :count)

    expect(Renalware::System::APILog.count).to eq(1)
    expect(Renalware::System::APILog.last.records_added).to eq(0)
    expect(patient.reload.current_modality.description.code).to eq("hd")
  end

  it "changes a matching patient's modality from HD to Transfer Out" do
    patient = create_hd_patient_and_session(
      last_session_date: 33.days.ago,
      hd_modality_start_date: 1.year.ago
    )

    expect do
      described_class.perform_now
    end
      .to change(Renalware::Modalities::Modality, :count).by(1)
      .and change(Renalware::System::APILog, :count).by(1)

    expect(Renalware::System::APILog.last.records_added).to eq(1)
    expect(patient.reload.current_modality.description.code).to eq("transfer_out")
  end
end
