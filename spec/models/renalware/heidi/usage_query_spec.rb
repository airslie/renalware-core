describe Renalware::Heidi::UsageQuery do
  before { travel_to(Time.zone.parse("2026-09-15 10:30")) }

  describe "#call" do
    it "returns monthly user and session counts for the requested calendar months" do
      september_user = create(:user)
      august_user = create(:user)

      create(:heidi_session, user: september_user, created_at: "2026-09-01 09:00")
      create(:heidi_session, user: september_user, created_at: "2026-09-10 09:00")
      create(:heidi_session, user: august_user, created_at: "2026-08-01 09:00")
      create(:heidi_session, user: august_user, created_at: "2026-08-02 09:00")
      create(:heidi_session, user: september_user, created_at: "2026-08-03 09:00")
      create(:heidi_session, user: september_user, created_at: "2026-06-30 23:59")
      create(
        :heidi_session,
        user: create(:user),
        status: :launch_failed,
        heidi_session_id: nil,
        heidi_patient_profile_id: nil,
        created_at: "2026-09-12 09:00"
      )

      rows = described_class.new(months: 3).call

      expect(rows.map(&:month)).to eq(
        [Date.new(2026, 9, 1), Date.new(2026, 8, 1), Date.new(2026, 7, 1)]
      )
      expect(rows.map(&:distinct_user_count)).to eq([1, 2, 0])
      expect(rows.map(&:session_count)).to eq([2, 3, 0])
    end

    it "defaults to 12 months" do
      expect(described_class.new(months: nil).months).to eq(12)
    end

    it "caps the number of requested months" do
      expect(described_class.new(months: 200).months).to eq(120)
    end
  end
end
