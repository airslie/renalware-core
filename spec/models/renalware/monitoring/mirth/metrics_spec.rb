module Renalware::Monitoring
  describe Mirth::Metrics do
    let(:meter_class) { Class.new { def create_gauge(name, **kwargs); end } }
    let(:meter) { instance_double(meter_class) }
    let(:instruments) { {} }
    let(:report) do
      instance_double(
        Mirth::StatsReport,
        site_id: "MSE",
        instance_id: "UAT",
        server_id: "386af0c6-920f-465d-b0a5-1a3c5088404c",
        reported_at: Time.zone.parse("2026-08-10T14:52:00.083Z"),
        channel_stats:
      )
    end
    let(:channel_stats) { instance_double(ActiveRecord::Relation, includes: channel_stats_relation) }
    let(:channel_stats_relation) { instance_double(ActiveRecord::Relation) }
    let(:channel_stat) do
      instance_double(
        Mirth::ChannelStats,
        channel: instance_double(
          Mirth::Channel,
          uuid: "c64da0c8-8c07-4caf-b76a-fa5ca07894d1",
          name: "Demographics ADT"
        ),
        state: "Started",
        received: 11_574,
        sent: 11_549,
        error: 0,
        filtered: 0,
        queued: 2
      )
    end

    before do
      if described_class.instance_variable_defined?(:@instruments)
        described_class.remove_instance_variable(:@instruments)
      end

      allow(described_class).to receive(:meter).and_return(meter)
      allow(meter).to receive(:create_gauge) do |name, **|
        instruments[name] = instance_spy("OpenTelemetry::Metrics::Gauge #{name}")
      end
      allow(channel_stats_relation).to receive(:find_each).and_yield(channel_stat)
    end

    it "records channel statistics as OpenTelemetry gauge metrics" do
      described_class.call(report:)

      expect(last_report_instrument).to have_received(:record).with(
        Time.zone.parse("2026-08-10T14:52:00.083Z").to_i,
        attributes: {
          "site_id" => "MSE",
          "instance_id" => "UAT",
          "server_id" => "386af0c6-920f-465d-b0a5-1a3c5088404c"
        }
      )
      expect(instruments.fetch("mirth_channel_queued")).to have_received(:record).with(
        2,
        attributes: channel_attributes
      )
      expect(instruments.fetch("mirth_channel_received_total")).to have_received(:record).with(
        11_574,
        attributes: channel_attributes
      )
      expect(instruments.fetch("mirth_channel_sent_total")).to have_received(:record).with(
        11_549,
        attributes: channel_attributes
      )
      expect(instruments.fetch("mirth_channel_error_total")).to have_received(:record).with(
        0,
        attributes: channel_attributes
      )
      expect(instruments.fetch("mirth_channel_filtered_total")).to have_received(:record).with(
        0,
        attributes: channel_attributes
      )
      expect(instruments.fetch("mirth_channel_state")).to have_received(:record).with(
        1,
        attributes: channel_attributes
      )
    end

    def channel_attributes
      {
        "site_id" => "MSE",
        "instance_id" => "UAT",
        "server_id" => "386af0c6-920f-465d-b0a5-1a3c5088404c",
        "channel_id" => "c64da0c8-8c07-4caf-b76a-fa5ca07894d1",
        "channel_name" => "Demographics ADT"
      }
    end

    def last_report_instrument
      instruments.fetch("mirth_stats_last_report_timestamp_seconds")
    end
  end
end
