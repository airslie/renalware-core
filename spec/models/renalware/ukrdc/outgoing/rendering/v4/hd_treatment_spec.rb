# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::HDTreatment do
        include XmlSpecHelper

        before { allow(Renalware.config).to receive(:ukrdc_site_code).and_return("XXX") }

        it "renders the treatment hospital unit type as the RR8 QBL05 code" do
          treatment = UKRDC::Treatment.new(
            discharge_reason_code: "9",
            modality_code: UKRDC::ModalityCode.new(txt_code: "1"),
            modality_id: 1,
            hd_profile_id: 2,
            started_on: Time.zone.parse("2019-12-13"),
            hospital_unit: Hospitals::Unit.new(unit_type: :hospital)
          )

          xml = format_xml(described_class.new(treatment:).xml)

          expect(xml).to match("<Attributes><QBL05>INCENTRE</QBL05></Attributes>")
        end
      end
    end
  end
end
