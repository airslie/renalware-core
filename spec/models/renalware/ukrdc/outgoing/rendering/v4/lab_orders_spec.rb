require "builder"

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::LabOrders do
        include XmlSpecHelper

        it "uses the pathology data range on the LabOrders element" do
          patient = instance_double(
            PatientPresenter,
            pathology_data_since: Date.parse("2011-01-01"),
            changes_up_until: Time.zone.parse("2021-02-01 09:02:02"),
            observation_requests: []
          )

          expected_xml = "<LabOrders start=\"2011-01-01\" stop=\"2021-02-01\"/>"

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to eq(expected_xml)
        end
      end
    end
  end
end
