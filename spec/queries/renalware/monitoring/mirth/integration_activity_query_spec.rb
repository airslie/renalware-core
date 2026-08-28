RSpec.describe Renalware::Monitoring::Mirth::IntegrationActivityQuery do
  before { travel_to(Time.zone.parse("2026-08-28 12:10:00")) }

  it "calculates reset-safe activity deltas and an equivalent-weekday median" do
    channel = create_channel
    create_stats(channel, "2026-08-13 23:50", received: 100, sent: 90, error: 2)
    create_stats(channel, "2026-08-14 09:10", received: 110, sent: 99, error: 3)
    create_stats(channel, "2026-08-20 23:50", received: 200, sent: 180, error: 4)
    create_stats(channel, "2026-08-21 09:10", received: 214, sent: 192, error: 5)
    create_stats(channel, "2026-08-27 23:50", received: 300, sent: 270, error: 6)
    create_stats(channel, "2026-08-28 09:10", received: 318, sent: 287, error: 7)
    create_stats(channel, "2026-08-28 10:10", received: 2, sent: 1, error: 0)
    create_stats(channel, "2026-08-28 11:40", received: 9, sent: 8, error: 2, queued: 4)

    snapshot = described_class.new.call

    expect(snapshot.received_last_hour).to eq(7)
    expect(snapshot.errors_today).to eq(3)
    expect(snapshot.queued_now).to eq(4)
    expect(snapshot.last_report_at).to eq(Time.zone.parse("2026-08-28 11:40"))
    expect(snapshot.today_received).to eq(18 => 18, 20 => 2, 23 => 7)
    expect(snapshot.today_sent).to eq(18 => 17, 20 => 1, 23 => 7)
    expect(snapshot.today_errors).to eq(18 => 1, 20 => 0, 23 => 2)
    expect(snapshot.comparison_days).to eq(2)
    expect(snapshot.typical_received.fetch(18)).to eq(12.0)
  end

  def create_channel
    group = Renalware::Monitoring::Mirth::ChannelGroup.create!(
      uuid: SecureRandom.uuid,
      name: "Clinical feeds"
    )
    Renalware::Monitoring::Mirth::Channel.create!(
      uuid: SecureRandom.uuid,
      name: "Pathology results",
      channel_group: group
    )
  end

  def create_stats(channel, time, **attributes)
    Renalware::Monitoring::Mirth::ChannelStats.create!(
      channel:,
      filtered: 0,
      queued: 0,
      created_at: Time.zone.parse(time),
      **attributes
    )
  end
end
