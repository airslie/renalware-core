module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::Name do
        include XmlSpecHelper

        it do
          patient = Patient.new(
            family_name: "F",
            given_name: "G",
            suffix: "S",
            title: "T"
          )

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Name use="L">
              <Prefix>T</Prefix>
              <Family>F</Family>
              <Given>G</Given>
              <Suffix>S</Suffix>
            </Name>
          XML

          xml = format_xml(described_class.new(nameable: patient).xml)

          expect(xml).to match_xml(expected_xml)
        end

        it "renders consent-refused placeholders when anonymised" do
          patient = Patient.new(
            family_name: "Jones",
            given_name: "Jack",
            suffix: "S",
            title: "T"
          )
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Name use="L">
              <Family>CONSENT</Family>
              <Given>REFUSED</Given>
            </Name>
          XML

          xml = format_xml(described_class.new(nameable: patient, anonymised: true).xml)

          expect(xml).to match_xml(expected_xml)
        end
      end
    end
  end
end
