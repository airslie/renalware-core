module Renalware
  module Monitoring
    module Mirth
      class Channel < ApplicationRecord
        validates :name, presence: true
        validates :uuid, presence: true, uniqueness: { case_sensitive: false }
        belongs_to :channel_group
        has_many(
          :channel_stats,
          class_name: "Renalware::Monitoring::Mirth::ChannelStats",
          dependent: :restrict_with_exception
        )
      end
    end
  end
end
