# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    describe Ingestion::AKIListener do
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
              PID|||Z999990^^^KCH||RABBIT^JESSICA^^^MS||19880924|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR||||||||||||||||||201010102359|
              ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
              ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
              OBR|1|^PCS|09B0099478^LA|XBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
              OBX|1|TX|PLT^PLT^HM||2||||||F|||201801251249||BHISVC01^BHI Authchecker
              OBR|1|^PCS|09B0099478^LA|AKI^AKI^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
              OBX|1|TX|AKI^AKI^HM||2||||||F|||201801251249||BHISVC01^BHI Authchecker
            HL7
            hl7.gsub(/^ */, "")
          end

          context "when the patient does not exist" do
            it "creates the patient with an AKI modality" do
              create(:pathology_lab, :uknown)
              create(:user, username: Renalware::SystemUser.username)
              create(:modality_description, :aki)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Patient, :count).by(1)

              patient = Renalware::Patient.last
              expect(patient.current_modality.description.code).to eq("aki")

              # This is a bit messy as we are also tyesting the Pathology::Listener here,
              # but we want to make sure the order of listeners is correct, so we are checking thath
              # the Pathology::Listener fired after the AKIListener and it found the patient the
              # AKIListener created, and saved the AKI result agains them.
              pathology_patient = Renalware::Pathology.cast_patient(patient)
              obrs = pathology_patient.observation_requests
              expect(obrs.count).to eq(2)
              obxs = obrs.last.observations
              expect(obxs.count).to eq(1)
              obx = obxs.first
              expect(obx.description.code).to match(/aki/i)
              expect(obx.result).to eq("2")
            end
          end

          context "when the patient exists and has no modality" do
            it "does not change their modality" do
              create(:pathology_lab, :uknown)
              create(:user, username: Renalware::SystemUser.username)
              create(:modality_description, :aki)
              create(:patient, local_patient_id: "Z999990", born_on: "19880924")

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Patient, :count).by(0)
              .and change(Renalware::Modalities::Modality, :count).by(1)
            end
          end

          context "when the patient exists and already has a modality" do
            it "does not change their modality" do
              create(:pathology_lab, :uknown)
              create(:user, username: Renalware::SystemUser.username)
              create(:modality_description, :aki)
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
              create(:modality, started_on: Date.parse("2015-04-01"), patient: patient)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Patient, :count).by(0)
              .and change(Renalware::Modalities::Modality, :count).by(0)
            end
          end

          describe "creation of aki_alert" do
            %i(hd pd low_clearance).each do |mod|
              it "no aki alert created when modality is #{mod}" do
                create(:pathology_lab, :uknown)
                create(:user, username: Renalware::SystemUser.username)
                create(:modality_description, :aki)
                patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
                create(
                  :modality,
                  started_on: Date.parse("2015-04-01"),
                  patient: patient,
                  description: create(:modality_description, mod)
                )

                expect {
                  Renalware::Feeds.message_processor.call(raw_message)
                }.not_to change(Renalware::Renal::AKIAlert, :count)
              end
            end

            %i(transplant aki).each do |mod|
              it "creates an aki alert created when modality is e.g. #{mod}" do
                create(:pathology_lab, :uknown)
                create(:user, username: Renalware::SystemUser.username)
                create(:modality_description, :aki)
                patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
                create(
                  :modality,
                  started_on: Date.parse("2015-04-01"),
                  patient: patient,
                  description: create(:modality_description, mod)
                )

                expect {
                  Renalware::Feeds.message_processor.call(raw_message)
                }.to change(Renalware::Renal::AKIAlert, :count).by(1)
              end
            end

            it "does not create an alert if one created in last 2 weeks" do
              create(:pathology_lab, :uknown)
              create(:user, username: Renalware::SystemUser.username)
              create(:modality_description, :aki)
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
              create(
                :modality,
                started_on: Date.parse("2015-04-01"),
                patient: patient,
                description: create(:modality_description, :transplant)
              )

              create(:aki_alert, patient_id: patient.id, created_at: 13.days.ago)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Renal::AKIAlert, :count).by(0)
            end
          end
        end
      end
    end
  end
end
