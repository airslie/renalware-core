module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::V4::PatientNumbers do
        include XmlSpecHelper

        it "renders the full renal registry id if present" do
          allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
          patient = Patient.new(renal_registry_id: "ABC123")
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumbers>
              <PatientNumber>
                <Number>RAJ_ABC123</Number>
                <Organization>UKRR_UID</Organization>
                <NumberType>NI</NumberType>
              </PatientNumber>
            </PatientNumbers>
          XML

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to eq(expected_xml)
        end

        it "renders the UKRR UID and NHS number if present" do
          allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
          patient = Patient.new(renal_registry_id: "ABC123", nhs_number: "9999999999")
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumbers>
              <PatientNumber>
                <Number>RAJ_ABC123</Number>
                <Organization>UKRR_UID</Organization>
                <NumberType>NI</NumberType>
              </PatientNumber>
              <PatientNumber>
                <Number>9999999999</Number>
                <Organization>NHS</Organization>
                <NumberType>NI</NumberType>
              </PatientNumber>
            </PatientNumbers>
          XML

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to eq(expected_xml)
        end

        it "renders the UKRR UID and first hospital number if present" do
          allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
          patient = Patient.new(
            renal_registry_id: "ABC123",
            local_patient_id: "",
            local_patient_id_2: "123"
          )

          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumbers>
              <PatientNumber>
                <Number>RAJ_ABC123</Number>
                <Organization>UKRR_UID</Organization>
                <NumberType>NI</NumberType>
              </PatientNumber>
              <PatientNumber>
                <Number>123</Number>
                <Organization>LOCALHOSP</Organization>
                <NumberType>MRN</NumberType>
              </PatientNumber>
            </PatientNumbers>
          XML

          actual_xml = format_xml(described_class.new(patient:).xml)

          expect(actual_xml).to eq(expected_xml)
        end

        it "renders the UKRR UID as NI and MRN when anonymised" do
          allow(Renalware.config).to receive(:ukrdc_sending_facility_name).and_return("RAJ")
          patient = Patient.new(
            renal_registry_id: "ABC123",
            nhs_number: "9999999999",
            local_patient_id: "123"
          )
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <PatientNumbers>
              <PatientNumber>
                <Number>RAJ_ABC123</Number>
                <Organization>UKRR_UID</Organization>
                <NumberType>NI</NumberType>
              </PatientNumber>
              <PatientNumber>
                <Number>RAJ_ABC123</Number>
                <Organization>UKRR_UID</Organization>
                <NumberType>MRN</NumberType>
              </PatientNumber>
            </PatientNumbers>
          XML

          actual_xml = format_xml(described_class.new(patient:, anonymised: true).xml)

          expect(actual_xml).to eq(expected_xml)
        end
      end
    end
  end
end
# if patient.nhs_number.present?
#   xml.PatientNumber do
#     xml.Number patient.nhs_number
#     xml.Organization "NHS"
#     xml.NumberType "NI"
#   end
# end

# Renalware.config.patient_hospital_identifiers.values.each do |field|
#   next if (number = patient.public_send(field)).blank?

#   xml.PatientNumber do
#     xml.Number number
#     xml.Organization "LOCALHOSP"
#     xml.NumberType "MRN"
#   end
#   break
# end
# end
