# frozen_string_literal: true

describe "Legacy letters" do
  let(:patient) { create(:patient, :minimal, by: @current_user) }
  let!(:legacy_letter) { create(:legacy_letter, patient:) }

  around do |example|
    original = Renalware.config.legacy_letters_enabled
    example.run
  ensure
    Renalware.config.legacy_letters_enabled = original
  end

  it "shows the patient's legacy letters when enabled" do
    Renalware.config.legacy_letters_enabled = true

    get patient_legacy_letters_path(patient)

    expect(response).to be_successful
    expect(response.body).to include("Imported clinic letter")
  end

  it "shows the imported legacy letter content when enabled" do
    Renalware.config.legacy_letters_enabled = true

    get patient_legacy_letter_path(patient, legacy_letter)

    expect(response).to be_successful
    expect(response.body).to include("Legacy body")
  end

  it "does not route to the legacy letters UI when disabled" do
    Renalware.config.legacy_letters_enabled = false

    expect {
      get patient_legacy_letters_path(patient)
    }.to raise_error(ActionController::RoutingError)
  end
end
