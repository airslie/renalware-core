describe Renalware::Medications::ExpiringHDPrescriptionsDateRange do
  before do
    allow(Renalware.config).to receive_messages(
      days_ahead_to_warn_named_consultant_about_expiring_hd_prescriptions: 14,
      days_behind_to_warn_named_consultant_about_expired_hd_prescriptions: 7
    )
  end

  it do
    freeze_time do
      expect(described_class.new.range)
        .to eq(7.days.ago.beginning_of_day..14.days.from_now.end_of_day)
    end
  end
end
