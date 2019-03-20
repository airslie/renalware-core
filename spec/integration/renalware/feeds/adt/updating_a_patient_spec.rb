# frozen_string_literal: true

require "rails_helper"

describe "Update patient information on receipt of an ADT~A31 HL7 message" do
  let(:local_patient_id) { "P123" }
  let(:family_name) { "SMITH" }
  let(:given_name) { "John" }
  let(:middle_name) { "Middling" }
  let(:prefix) { "Sir" }

  let(:message) do
    hl7 = <<-HL7
      MSH|^~\&|ADT|iSOFT Engine|eGate|Kings|20150122154918||ADT^A31|897847653|P|2.3
      EVN|A31|20150122154918
      PID|1||#{local_patient_id}||#{family_name}^#{given_name}^#{middle_name}^^#{prefix}||19720822000000|M||Not Specified|34 Florence Road^SOUTH CROYDON^Surrey^^CR2 0PP^ZZ993CZ^HOME^QAD||0123456789|5554443333|NSP||NSP|||||Not Specified|.|DNU||8||NSP|20150122154801|Y
      PD1||||||||||||
      PV1|1|R|FISK^^^KCH||||||||||||||||||||||||||||||||||||||||||||||
    HL7
    hl7.gsub(/^[ ]*/, "")
  end

  context "when the patient exists in Renalware" do
    it "updates their information" do
      patient = create(:patient, local_patient_id: local_patient_id)

      FeedJob.new(message).perform

      patient.reload
      expect(patient.family_name).to eq(family_name)
      expect(patient.given_name).to eq(given_name)
      expect(patient.prefix).to eq(prefix)
    end
  end
end
