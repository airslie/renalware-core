module Renalware::Monitoring
  describe Mirth::StatsReport do
    it { is_expected.to belong_to(:api_credential).class_name("Renalware::API::Credential") }

    it do
      is_expected
        .to have_many(:channel_stats)
        .class_name("Renalware::Monitoring::Mirth::ChannelStats")
        .dependent(:restrict_with_exception)
    end

    it { is_expected.to validate_presence_of(:report_id) }
    it { is_expected.to validate_presence_of(:source) }
    it { is_expected.to validate_presence_of(:site_id) }
    it { is_expected.to validate_presence_of(:instance_id) }
    it { is_expected.to validate_presence_of(:reported_at) }
  end
end
