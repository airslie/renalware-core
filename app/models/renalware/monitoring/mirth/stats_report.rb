module Renalware
  module Monitoring
    module Mirth
      class StatsReport < ApplicationRecord
        belongs_to :api_credential, class_name: "Renalware::API::Credential"
        has_many(
          :channel_stats,
          class_name: "Renalware::Monitoring::Mirth::ChannelStats",
          dependent: :restrict_with_exception
        )

        validates :report_id, presence: true, uniqueness: true
        validates :source, :site_id, :instance_id, :reported_at, presence: true
      end
    end
  end
end
