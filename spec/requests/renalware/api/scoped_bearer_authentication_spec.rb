describe "Scoped API bearer authentication" do
  let(:service_user) { create(:user) }
  let(:payload) do
    {
      schema_version: 1,
      report_id: SecureRandom.uuid,
      reported_at: "2026-08-09T10:15:00Z",
      source: "mirth_connect",
      site_id: "hospital-a",
      instance_id: "renalware-production",
      server_id: "e64f0bc9-9b8a-4618-ab2f-da497b53a7fe",
      channels: [
        {
          id: SecureRandom.uuid,
          name: "Pathology results",
          state: "STARTED",
          received: 1,
          sent: 1,
          error: 0,
          filtered: 0,
          queued: 0
        }
      ]
    }
  end

  def bearer_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  it "allows an active service user with the required credential scope" do
    issued = Renalware::API::Credential.issue!(
      user: service_user,
      name: "Mirth statistics writer",
      scopes: [Renalware::API::Credential::MIRTH_STATISTICS_WRITE]
    )

    post(
      api_v1_monitoring_mirth_channel_stats_path,
      params: payload,
      headers: bearer_headers(issued.token),
      as: :json
    )

    expect(response).to be_successful
  end

  it "does not bypass the service user's Devise account status" do
    service_user.update!(approved: false)
    issued = Renalware::API::Credential.issue!(
      user: service_user,
      name: "Mirth statistics writer",
      scopes: [Renalware::API::Credential::MIRTH_STATISTICS_WRITE]
    )

    post(
      api_v1_monitoring_mirth_channel_stats_path,
      params: payload,
      headers: bearer_headers(issued.token),
      as: :json
    )

    expect(response).to be_unauthorized
  end

  it "does not allow a credential without the required scope" do
    issued = Renalware::API::Credential.issue!(
      user: service_user,
      name: "Outgoing documents",
      scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_READ]
    )

    post(
      api_v1_monitoring_mirth_channel_stats_path,
      params: payload,
      headers: bearer_headers(issued.token),
      as: :json
    )

    expect(response).to be_unauthorized
  end
end
