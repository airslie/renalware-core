# See
# https://www.ukrdc.org/2015/09/15/ukrdc-schema/
# https://github.com/renalreg/ukrdc
#
xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

namespace_and_schema = {
  "xmlns:ukrdc" => "http://www.rixg.org.uk/",
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xsi:schemaLocation" => [
    "http://www.rixg.org.uk/",
    Renalware::Engine.root.join("vendor", "xsd", "ukrdc/UKRDC.xsd")
  ].join(" ")
}

# Start of <ukrdc:Patient>
xml.ukrdc(:PatientRecord, namespace_and_schema) do
  render "sending_facility", builder: xml, patient: patient
  render "patient", builder: xml, patient: patient
  render "lab_orders", builder: xml, patient: patient
  render "social_histories", builder: xml, patient: patient
  render "family_histories", builder: xml, patient: patient
  render "observations", builder: xml, patient: patient
  render "allergies", builder: xml, patient: patient
  render "diagnoses", builder: xml, patient: patient
  render "documents", builder: xml, patient: patient
  render "encounters", builder: xml, patient: patient
  render "program_memberships", builder: xml, patient: patient
  render "clinical_relationships", builder: xml, patient: patient
  render "surveys", builder: xml, patient: patient
end
