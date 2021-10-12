# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    describe AKIListener do
      subject(:listener) { described_class.new }

      describe "#oru_message_arrived" do
        context "when the messages does not contain an AKI test score result" do
          it "does not try to add the patient" do
            hl7_message = instance_double(
              Renalware::Feeds::HL7Message,
              observation_requests: []
            )

            allow(Patients::Ingestion::Commands::AddPatient).to receive(:call)

            described_class.new.oru_message_arrived(hl7_message: hl7_message)

            expect(Patients::Ingestion::Commands::AddPatient).not_to have_received(:call)
          end
        end

        # This test is more end to end!
        context "when the messages contains an AKI test score result" do
          let(:raw_message) do
            hl7 = <<-HL7
              MSH|^~\&|HM|LBE|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
              PID|||Z999990^^^KCH||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR|||||||||||||||||||
              ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
              ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
              OBR|1|^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
              OBX|1|TX|AKI^AKI^HM||2||||||F|||201801251249||BHISVC01^BHI Authchecker
            HL7
            hl7.gsub(/^ */, "")
          end

          it "creates the patient with an AKI modality" do
            create(:user, username: Renalware::SystemUser.username)
            create(:modality_description, :aki)

            hl7_message = Renalware::Feeds::MessageParser.parse(raw_message)

            expect {
              described_class.new.oru_message_arrived(hl7_message: hl7_message)
            }.to change(Renalware::Patient, :count).by(1)

            patient = Renalware::Patient.last
            expect(patient.current_modality.description.code).to eq("aki")
          end
        end
      end
    end
  end
end
