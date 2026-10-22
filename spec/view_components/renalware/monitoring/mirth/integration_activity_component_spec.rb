RSpec.describe Renalware::Monitoring::Mirth::IntegrationActivityComponent, type: :component do
  before do
    travel_to(Time.zone.parse("2026-08-28 12:10:00"))
    allow(Renalware.config).to receive(:monitoring_mirth_enabled).and_return(true)
    Rails.cache.clear
  end

  it "renders integration summaries and an embedded Highcharts configuration",
     :aggregate_failures do
    snapshot = Renalware::Monitoring::Mirth::IntegrationActivityQuery::Snapshot.new(
      received_last_hour: 42,
      errors_today: 2,
      queued_now: 3,
      last_report_at: 10.minutes.ago,
      today_received: { 18 => 20, 19 => 22 },
      today_sent: { 18 => 19, 19 => 21 },
      today_errors: { 18 => 0, 19 => 2 },
      typical_received: { 18 => 18.5, 19 => 20.0 },
      comparison_days: 6
    )
    query = instance_double(Renalware::Monitoring::Mirth::IntegrationActivityQuery, call: snapshot)

    render_inline(
      described_class.new(current_user: create(:user), query:, wrapper_classes: "min-w-0")
    )

    expect(page).to have_text("Integration activity today")
    expect(page).to have_css("dt", text: "Received last hour")
    expect(page).to have_css("dd", text: "42")
    expect(page).to have_css("dt", text: "Errors today")
    expect(page).to have_css("dd.text-red-700", text: "2")
    expect(page).to have_css("dt", text: "Queued now")
    expect(page).to have_css("dd.text-amber-700", text: "3")
    expect(page).to have_css("dd.text-green-700", text: "10 minutes ago")
    expect(page).to have_css("dl.clear-both.grid.overflow-hidden")

    chart = page.find("[data-controller='charts-raw']")
    configuration = JSON.parse(chart["data-charts-raw-config-value"])
    expect(configuration.fetch("series").pluck("name"))
      .to eq(["Received", "Sent", "Typical received", "Errors"])
    expect(configuration.dig("series", 3, "yAxis")).to eq(1)
  end

  it "renders a useful empty state when no reports have arrived" do
    snapshot = Renalware::Monitoring::Mirth::IntegrationActivityQuery::Snapshot.new(
      received_last_hour: 0,
      errors_today: 0,
      queued_now: 0,
      last_report_at: nil,
      today_received: {},
      today_sent: {},
      today_errors: {},
      typical_received: {},
      comparison_days: 0
    )
    query = instance_double(Renalware::Monitoring::Mirth::IntegrationActivityQuery, call: snapshot)

    render_inline(described_class.new(current_user: create(:user), query:))

    expect(page).to have_text("Waiting for Mirth monitoring data")
    expect(page).to have_text("Never received")
    expect(page).to have_text("No Mirth monitoring data has been received today")
    expect(page).to have_no_css("[data-controller='charts-raw']")
  end
end
