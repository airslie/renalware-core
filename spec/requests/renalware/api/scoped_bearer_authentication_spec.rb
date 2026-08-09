describe "Scoped API bearer authentication" do
  let(:service_user) { create(:user) }
  let(:patient) { create(:patient, local_patient_id: "MRN123") }

  def bearer_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  it "allows an active service user with a patient-read credential" do
    issued = Renalware::API::Credential.issue!(
      user: service_user,
      name: "Patient reader",
      scopes: [Renalware::API::Credential::PATIENTS_READ]
    )

    get(
      api_v1_patient_path(id: patient.local_patient_id),
      headers: bearer_headers(issued.token)
    )

    expect(response).to be_successful
  end

  it "does not bypass the service user's Devise account status" do
    service_user.update!(approved: false)
    issued = Renalware::API::Credential.issue!(
      user: service_user,
      name: "Patient reader",
      scopes: [Renalware::API::Credential::PATIENTS_READ]
    )

    get(
      api_v1_patient_path(id: patient.local_patient_id),
      headers: bearer_headers(issued.token)
    )

    expect(response).to be_unauthorized
  end

  it "does not allow an outgoing-documents credential to read patients" do
    issued = Renalware::API::Credential.issue!(
      user: service_user,
      name: "Outgoing documents",
      scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_READ]
    )

    get(
      api_v1_patient_path(id: patient.local_patient_id),
      headers: bearer_headers(issued.token)
    )

    expect(response).to be_unauthorized
  end
end
