# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients::Ingestion
  describe Commands::AddOrUpdatePatient do
    include HL7Helpers
    include PatientsSpecHelper
    subject(:service) { described_class }

    def create_deceased_patient_with_incomplete_death_attributes(by:)
      create(:patient, local_patient_id: "A123", died_on: nil, first_cause: nil).tap do |patient|
        set_modality(
          patient: patient,
          modality_description: create(:modality_description, :death),
          by: by
        )
      end
    end

    describe "#call" do
      context "when the patient has the death modality but no cause of death or died_on set" do
        it "can update the patient without triggering missing cause of death validations" do
          user = create(:user, username: Renalware::SystemUser.username)
          patient = create_deceased_patient_with_incomplete_death_attributes(by: user)
          hl7_data = OpenStruct.new(
            hospital_number: "A123",
            nhs_number: "9999999999",
            family_name: "new_family_name",
            given_name: "new_given_name"
          )

          hl7_message = hl7_message_from_file("ADT_A31", hl7_data)

          expect(hl7_message.patient_identification.internal_id).to eq("A123")
          described_class.new(hl7_message).call

          expect(patient.reload.nhs_number).to eq("9999999999")
        end
      end
    end
  end
end
