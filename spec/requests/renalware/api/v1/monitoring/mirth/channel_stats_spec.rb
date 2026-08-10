describe "Mirth channel statistics API" do
  let(:api_user) { create(:user) }
  let(:issued_credential) do
    Renalware::API::Credential.issue!(
      user: api_user,
      name: "Mirth statistics",
      scopes: [Renalware::API::Credential::MIRTH_STATISTICS_WRITE]
    )
  end
  let(:headers) { { "Authorization" => "Bearer #{issued_credential.token}" } }
  let(:reported_at) { "2026-08-09T10:15:00Z" }
  let(:payload) do
    {
      schema_version: 1,
      report_id: "59e995a4-76e8-4e63-bdd8-a9bc94ba4ff6",
      reported_at:,
      source: "mirth_connect",
      site_id: "hospital-a",
      instance_id: "renalware-production",
      server_id: "e64f0bc9-9b8a-4618-ab2f-da497b53a7fe",
      channels: [
        {
          id: "a7f684ca-a58a-4e7e-b4a9-8f13a7977cf9",
          name: "Pathology results",
          state: "STARTED",
          received: 12043,
          sent: 12040,
          error: 2,
          filtered: 1,
          queued: 3
        },
        {
          id: "0a5c30cc-b3ac-4981-a64b-d608a1dadaf9",
          name: "GP letters",
          state: "PAUSED",
          received: 100,
          sent: 90,
          error: 4,
          filtered: 1,
          queued: 5
        }
      ]
    }
  end

  it "accepts and persists a channel statistics report" do
    post api_v1_monitoring_mirth_channel_stats_path, params: payload, headers:, as: :json

    expect(response).to have_http_status(:created)
    expect(response.parsed_body).to eq(
      "report_id" => payload.fetch(:report_id),
      "status" => "accepted"
    )

    report = Renalware::Monitoring::Mirth::StatsReport.find_by!(
      report_id: payload.fetch(:report_id)
    )
    expect(report).to have_attributes(
      source: "mirth_connect",
      site_id: "hospital-a",
      instance_id: "renalware-production",
      server_id: "e64f0bc9-9b8a-4618-ab2f-da497b53a7fe",
      reported_at: Time.zone.parse(reported_at),
      api_credential: issued_credential.credential
    )
    expect(report.channel_stats.count).to eq(2)

    pathology_stats = report.channel_stats.joins(:channel).find_by!(
      channel: { name: "Pathology results" }
    )
    expect(pathology_stats).to have_attributes(
      state: "STARTED",
      received: 12043,
      sent: 12040,
      error: 2,
      filtered: 1,
      queued: 3,
      created_at: Time.zone.parse(reported_at)
    )
  end

  it "treats a repeated report id as an idempotent retry" do
    post api_v1_monitoring_mirth_channel_stats_path, params: payload, headers:, as: :json
    post api_v1_monitoring_mirth_channel_stats_path, params: payload, headers:, as: :json

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body).to include("status" => "duplicate")
    expect(Renalware::Monitoring::Mirth::StatsReport.count).to eq(1)
    expect(Renalware::Monitoring::Mirth::ChannelStats.count).to eq(2)
  end

  it "rejects a credential without the statistics-write scope" do
    other_credential = Renalware::API::Credential.issue!(
      user: api_user,
      name: "Outgoing documents reader",
      scopes: [Renalware::API::Credential::OUTGOING_DOCUMENTS_READ]
    )

    post(
      api_v1_monitoring_mirth_channel_stats_path,
      params: payload,
      headers: { "Authorization" => "Bearer #{other_credential.token}" },
      as: :json
    )

    expect(response).to be_unauthorized
  end

  it "does not allow legacy query-string authentication" do
    api_user.update!(authentication_token: "legacy-token")

    post(
      api_v1_monitoring_mirth_channel_stats_path(
        username: api_user.username,
        token: api_user.authentication_token
      ),
      params: payload,
      as: :json
    )

    expect(response).to be_unauthorized
  end

  it "rejects an invalid report without writing partial data" do
    payload[:channels][1][:queued] = -1

    post api_v1_monitoring_mirth_channel_stats_path, params: payload, headers:, as: :json

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body.fetch("errors").to_s).to include("greater than or equal to 0")
    expect(Renalware::Monitoring::Mirth::StatsReport.count).to be_zero
    expect(Renalware::Monitoring::Mirth::ChannelStats.count).to be_zero
  end

  it "rejects duplicate channel ids within a report" do
    payload[:channels][1][:id] = payload[:channels][0][:id]

    post api_v1_monitoring_mirth_channel_stats_path, params: payload, headers:, as: :json

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.parsed_body.fetch("errors").to_s).to include("duplicate channel ids")
  end
end
