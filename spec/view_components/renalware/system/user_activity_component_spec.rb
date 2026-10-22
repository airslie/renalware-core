RSpec.describe Renalware::System::UserActivityComponent, type: :component do
  before { travel_to(Time.zone.parse("2026-08-28 12:10:00")) }

  it "renders headline activity figures and an embedded Highcharts configuration",
     :aggregate_failures do
    snapshot = Renalware::System::UserActivityQuery::Snapshot.new(
      active_now: 3,
      active_today: 12,
      peak_count: 7,
      peak_bucket: 19,
      today: { 18 => 4, 19 => 7 },
      typical: { 18 => 3.5, 19 => 5.0 },
      comparison_days: 6
    )
    query = instance_double(Renalware::System::UserActivityQuery, call: snapshot)

    render_inline(
      described_class.new(current_user: create(:user), query:, wrapper_classes: "min-w-0")
    )

    expect(page).to have_css(".min-w-0")
    expect(page).to have_no_css(".columns")
    expect(page).to have_css("dl.clear-both.grid.overflow-hidden")
    expect(page).to have_text("User activity today")
    expect(page).to have_css("dt", text: "Active now")
    expect(page).to have_css("dd", text: "3")
    expect(page).to have_css("dt", text: "Active today")
    expect(page).to have_css("dd", text: "12")
    expect(page).to have_css("dt", text: "Peak today")
    expect(page).to have_css("dd", text: "7 at 09:30")
    expect(page).to have_text("last 6 equivalent weekdays")

    chart = page.find("[data-controller='charts-raw']")
    configuration = JSON.parse(chart["data-charts-raw-config-value"])
    expect(configuration.dig("series", 0, "name")).to eq("Today")
    expect(configuration.dig("series", 1, "name")).to eq("Typical")
    expect(configuration.dig("series", 0, "data").map(&:last)).to eq([4, 7])
  end
end
