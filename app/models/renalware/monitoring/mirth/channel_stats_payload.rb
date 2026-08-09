module Renalware
  module Monitoring
    module Mirth
      class ChannelStatsPayload
        include ActiveModel::Model

        UUID_FORMAT = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
        MAX_CHANNELS = 1000

        attr_accessor(
          :schema_version,
          :report_id,
          :reported_at,
          :source,
          :site_id,
          :instance_id,
          :server_id
        )
        attr_reader :channels

        validates :schema_version, inclusion: { in: [1] }
        validates :report_id, :reported_at, :source, :site_id, :instance_id, presence: true
        validates :report_id, format: { with: UUID_FORMAT }, allow_blank: true
        validates :server_id, format: { with: UUID_FORMAT }, allow_blank: true
        validates :source, inclusion: { in: ["mirth_connect"] }
        validates :site_id, :instance_id, length: { maximum: 255 }
        validate :reported_at_is_iso8601
        validate :channels_are_valid

        def initialize(attributes)
          attributes = attributes.to_h.deep_symbolize_keys
          channel_attributes = attributes.delete(:channels)
          @channels_provided = channel_attributes.is_a?(Array)
          @channels = Array(channel_attributes).map { |item| ChannelPayload.new(item) }
          super(attributes) # rubocop:disable Style/SuperArguments
        end

        def reported_at_time
          @reported_at_time ||= Time.iso8601(reported_at.to_s)
        rescue ArgumentError
          nil
        end

        private

        def reported_at_is_iso8601
          errors.add(:reported_at, "must be an ISO 8601 timestamp") if reported_at_time.nil?
        end

        def channels_are_valid
          errors.add(:channels, "must be an array") unless @channels_provided
          if channels.size > MAX_CHANNELS
            errors.add(:channels, "contains more than #{MAX_CHANNELS} channels")
          end
          errors.add(:channels, "contains duplicate channel ids") if duplicate_channel_ids?

          channels.each_with_index do |channel, index|
            next if channel.valid?

            channel.errors.each do |error|
              errors.add("channels.#{index}.#{error.attribute}", error.message)
            end
          end
        end

        def duplicate_channel_ids?
          ids = channels.filter_map { |channel| channel.id&.downcase }
          ids.uniq.size != ids.size
        end

        class ChannelPayload
          include ActiveModel::Model

          COUNT_FIELDS = %i(received sent error filtered queued).freeze

          attr_accessor :id, :name, :state, *COUNT_FIELDS

          validates :id, :name, presence: true
          validates :id, format: { with: UUID_FORMAT }, allow_blank: true
          validates :name, length: { maximum: 255 }
          validates :state, length: { maximum: 50 }, allow_blank: true
          validates(
            *COUNT_FIELDS,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
          )
        end
      end
    end
  end
end
