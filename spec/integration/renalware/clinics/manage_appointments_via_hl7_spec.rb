# frozen_string_literal: true

require "rails_helper"

# Tests
# A05 create appointment
# - ignore if patient not in RW
# - ignore if clinic not found
# - what happens if consultant not found?
# - create appoint, test stores spellid
# A38 delete appointment
# - ignore if patient not in RW
# - ignore if spellid not found in appints
# - delete appoint

describe "manage appointments via HL7 ADT messages" do
  include HL7Helpers

  describe "ADT^A05 delete/cancel appointment" do
    context "when patient is not found in Renalware" do
      it "ignores the message" do
        data = OpenStruct.new(
          patient: OpenStruct.new(
            nhs_number: "1000000000",
            hospital_number: "123"
          ),
          clinic: OpenStruct.new(
            code: "TestClinic"
          ),
          consultant: OpenStruct.new
        )
        msg = hl7_message_from_file("clinics/ADT_A38_cancel_appointment", data)

        expect(msg.patient_identification.nhs_number).to eq("1000000000")
        expect(msg.patient_identification.hospital_identifiers[:"PAS Number"]).to eq("123")
      end
    end
  end
end
