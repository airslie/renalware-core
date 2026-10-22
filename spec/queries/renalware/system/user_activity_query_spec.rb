RSpec.describe Renalware::System::UserActivityQuery do
  before { travel_to(Time.zone.parse("2026-08-28 12:10:00")) }

  describe "#call" do
    it "summarises today's active users and compares completed intervals with prior weekdays" do
      first_user = create(:user, last_activity_at: 5.minutes.ago)
      second_user = create(:user, last_activity_at: 40.minutes.ago)
      hidden_user = create(:user, hidden: true, last_activity_at: 5.minutes.ago)

      track_action(first_user, "2026-08-28 09:05")
      track_action(first_user, "2026-08-28 09:15")
      track_action(second_user, "2026-08-28 09:20")
      track_action(first_user, "2026-08-28 10:05")
      track_action(first_user, "2026-08-28 12:05")
      track_action(hidden_user, "2026-08-28 10:10")
      track_action(first_user, "2026-08-21 09:05")
      track_action(first_user, "2026-08-21 09:35")
      track_action(first_user, "2026-08-14 09:05")
      track_action(second_user, "2026-08-14 09:10")
      track_event(first_user, "2026-08-28 08:00", name: "signin")

      snapshot = described_class.new.call

      expect(snapshot.active_now).to eq(1)
      expect(snapshot.active_today).to eq(2)
      expect(snapshot.peak_count).to eq(2)
      expect(snapshot.peak_bucket).to eq(18)
      expect(snapshot.today).to eq(18 => 2, 20 => 1)
      expect(snapshot.comparison_days).to eq(2)
      expect(snapshot.typical.fetch(18)).to eq(1.5)
      expect(snapshot.typical.fetch(19)).to eq(0.5)
      expect(snapshot.typical.fetch(20)).to eq(0.0)
    end
  end

  def track_action(user, time)
    track_event(user, time, name: "action")
  end

  def track_event(user, time, name:)
    time = Time.zone.parse(time)
    visit = create_visit(user, time)
    Renalware::System::Event.create!(visit:, user:, name:, time:, properties: {})
  end

  def create_visit(user, time)
    Renalware::System::Visit.create!(
      user:, started_at: time, visit_token: SecureRandom.uuid, visitor_token: SecureRandom.uuid
    )
  end
end
