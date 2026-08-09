module Renalware::Monitoring
  describe Mirth::Channel do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to belong_to(:channel_group) }

    it do
      is_expected
        .to have_many(:channel_stats)
        .class_name("Renalware::Monitoring::Mirth::ChannelStats")
        .dependent(:restrict_with_exception)
    end
  end
end
