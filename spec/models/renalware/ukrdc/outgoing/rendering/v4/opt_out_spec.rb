module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::OptOut do
        include XmlSpecHelper

        before do
          allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("Test")
        end

        context "when patient has not requested UKRDC anonymisation" do
          it "renders nothing" do
            patient = build(:patient, ukrdc_anonymise: false)

            expect(described_class.new(patient:).xml).to be_nil
          end
        end

        context "when patient has requested UKRDC anonymisation" do
          context "when a decision date was not specified" do
            it "uses 01/01/1900" do
              patient = build(
                :patient,
                ukrdc_anonymise: true,
                ukrdc_anonymise_decision_on: nil
              )
              expected_xml = <<~XML.squish.gsub("> <", "><")
                <OptOut>
                  <EnteredAt>
                    <CodingStandard>RR1+</CodingStandard>
                    <Code>Test</Code>
                  </EnteredAt>
                  <ProgramName>UKRR</ProgramName>
                  <FromTime>1900-01-01</FromTime>
                </OptOut>
              XML

              xml = format_xml(described_class.new(patient:).xml)

              expect(xml).to match_xml(expected_xml)
            end
          end

          it do
            patient = build(
              :patient,
              ukrdc_anonymise: true,
              ukrdc_anonymise_decision_on: "2024-07-16",
              ukrdc_anonymise_recorded_by: "Dr X"
            )
            expected_xml = <<~XML.squish.gsub("> <", "><")
              <OptOut>
                <EnteredBy>
                  <CodingStandard>LOCAL</CodingStandard>
                  <Code>Dr X</Code>
                </EnteredBy>
                <EnteredAt>
                  <CodingStandard>RR1+</CodingStandard>
                  <Code>Test</Code>
                </EnteredAt>
                <ProgramName>UKRR</ProgramName>
                <FromTime>2024-07-16</FromTime>
              </OptOut>
            XML

            xml = format_xml(described_class.new(patient:).xml)

            expect(xml).to match_xml(expected_xml)
          end
        end
      end
    end
  end
end
