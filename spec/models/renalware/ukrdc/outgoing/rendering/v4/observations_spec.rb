require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::Observations do
        include XmlSpecHelper

        it "uses the child data range on the Observations element" do
          patient = instance_double(
            PatientPresenter,
            child_data_since: Time.zone.parse("2020-12-02 10:01:01"),
            changes_up_until: Time.zone.parse("2021-02-01 09:02:02"),
            clinic_visits: [],
            finished_hd_sessions: []
          )

          expected_xml = "<Observations start=\"2020-12-02\" stop=\"2021-02-01\"/>"

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to eq(expected_xml)
        end
      end
    end
  end
end
