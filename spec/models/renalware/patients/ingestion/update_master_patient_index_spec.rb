# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients
  describe Ingestion::UpdateMasterPatientIndex do
    include HL7Helpers
    subject(:service) { described_class }

    describe "#call" do
      context "when an ORU pathology message" do
        it "does not update the master patient index" do
          patient = build_stubbed(:patient)
          hl7_message = hl7_message_from_file("ORU_R01.hl7", patient)
          expect(hl7_message).to be_oru

          expect {
            service.call(hl7_message)
          }.not_to change(Abridgement, :count)
        end
      end

      context "when an ADT A31 message" do
        context "when the patient does not exist in Renalware" do
          context "when the patient does not exist in the master patient index" do
            it "adds the patient to the master patient index" do
              patient = build_stubbed(:patient)
              hl7_message = hl7_message_from_file("ADT_A31.hl7", patient)
              expect(hl7_message).to be_adt

              expect {
                service.call(hl7_message)
              }.to change(Abridgement, :count).by(1)
            end
          end

          context "when the patient already exist in the master patient index" do
            it "updates the patient to the master patient index" do
              abridged_patient = create(
                :abridged_patient,
                hospital_number: "A123",
                born_on: "1900-01-01"
              )
              patient = build_stubbed(
                :patient,
                local_patient_id: "A123",
                family_name: "new_family_name",
                given_name: "new_given_name",
                born_on: "2002-02-01",
                died_on: "2003-03-02"
              )
              hl7_message = hl7_message_from_file("ADT_A31.hl7", patient)
              expect(hl7_message).to be_adt

              expect { service.call(hl7_message) }.not_to change(Abridgement, :count)

              expect(abridged_patient.reload).to have_attributes(
                hospital_number: "A123",
                family_name: "new_family_name",
                given_name: "new_given_name",
                born_on: Time.zone.parse("2002-02-01").to_date,
                died_at: Time.zone.parse("2003-03-02").to_date
              )
            end
          end
        end
      end
    end
  end
end
