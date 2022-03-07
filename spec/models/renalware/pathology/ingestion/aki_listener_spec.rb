# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    describe Ingestion::AKIListener do
      subject(:listener) { described_class.new }

      def create_cre_observation(patient, cre_date, cre_result)
        cre = create(:pathology_observation_description, :cre)

        request = create(
          :pathology_observation_request,
          patient: Renalware::Pathology.cast_patient(patient)
        )
        create(
          :pathology_observation,
          request: request,
          description: cre,
          result: cre_result,
          observed_at: cre_date
        )
      end

      before do
        create(:pathology_lab, :uknown)
        create(:user, username: Renalware::SystemUser.username)
        create(:modality_description, :aki)
      end

      describe "#oru_message_arrived" do
        context "when the message does not contain an AKI test score result" do
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
          let(:dob) { "19880924" }
          let(:raw_message) do
            hl7 = <<-HL7
              MSH|^~\&|HM|RAJ01|SCM||20091112164645||ORU^R01|1258271|P|2.3.1|||AL||||
              PID|||Z999990^^^KCH||RABBIT^JESSICA^^^MS||#{dob}|F|||18 RABBITHOLE ROAD^LONDON^^^SE8 8JR||||||||||||||||||201010102359|
              ORC|RE|0031111111^PCS|18T1111111^LA||CM||||201801221418|||xxx^xx, xxxx
              ORC|RE|^PCS|09B0099478^LA||CM||||200911111841|||MID^KINGS MIDWIVES|||||||
              OBR|1|^PCS|09B0099478^LA|XBC^FULL BLOOD COUNT^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
              OBX|1|TX|CRE^CRE^HM||23||||||F|||201801151249||BHISVC01^BHI Authchecker
              OBR|1|^PCS|09B0099478^LA|AKI^AKI^MB||200911111841|200911111841|||||||200911111841|B^Blood|MID^KINGS MIDWIVES||09B0099478||||200911121646||HM|F||||||||||||||||||
              OBX|1|TX|AKI^AKI^HM||2||||||F|||201801251249||BHISVC01^BHI Authchecker
            HL7
            hl7.gsub(/^ */, "")
          end

          context "when the patient does not exist" do
            it "creates the patient with an AKI modality" do
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
              create(:patient, local_patient_id: "Z999990", born_on: "19880924")

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Patient, :count).by(0)
              .and change(Renalware::Modalities::Modality, :count).by(1)
            end
          end

          context "when the patient exists but is < 17 yo" do
            let(:dob) { 17.years.ago + 1.day }

            it "does not create an AKI alert" do
              create(:patient, local_patient_id: "Z999990", born_on: dob)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Patient, :count).by(0)
              .and change(Renalware::Modalities::Modality, :count).by(0)
              .and change(Renalware::Renal::AKIAlert, :count).by(0)
            end
          end

          context "when the patient exists and already has a modality" do
            it "does not change their modality" do
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
              create(:modality, started_on: Date.parse("2015-04-01"), patient: patient)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Patient, :count).by(0)
              .and change(Renalware::Modalities::Modality, :count).by(0)
            end
          end

          describe "creation of aki_alert" do
            context "when patient's curr modality description is marked 'ignore_for_aki_alerts'" do
              it "does not create the alert" do
                patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
                create(
                  :modality,
                  started_on: Date.parse("2015-04-01"),
                  patient: patient,
                  description: create(:hd_modality_description, ignore_for_aki_alerts: true)
                )

                expect {
                  Renalware::Feeds.message_processor.call(raw_message)
                }.not_to change(Renalware::Renal::AKIAlert, :count)
              end
            end

            context "when patient's curr modality is not marked 'ignore_for_aki_alerts'" do
              it "creates the alert" do
                patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
                create(
                  :modality,
                  started_on: Date.parse("2015-04-01"),
                  patient: patient,
                  description: create(:hd_modality_description, ignore_for_aki_alerts: false)
                )

                expect {
                  Renalware::Feeds.message_processor.call(raw_message)
                }.to change(Renalware::Renal::AKIAlert, :count).by(1)

                expect(Renalware::Renal::AKIAlert.last).to have_attributes(
                  max_aki: 2,
                  aki_date: Date.parse("201801251249"),
                  max_cre: nil,
                  cre_date: nil
                )
              end
            end

            it "stores latest CRE result and date if available" do
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")

              # Create a previous CRE observation so there is something to populate the alert with
              cre_date = Date.parse("20180101")
              cre_result = 50
              create_cre_observation(patient, cre_date, cre_result)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Renal::AKIAlert, :count).by(1)

              expect(Renalware::Renal::AKIAlert.last).to have_attributes(
                max_aki: 2,
                aki_date: Date.parse("201801251249"),
                max_cre: cre_result,
                cre_date: cre_date
              )
            end

            it "does not create an alert if one created in 7 days" do
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
              create(
                :modality,
                started_on: Date.parse("2015-04-01"),
                patient: patient,
                description: create(:modality_description, :transplant)
              )

              create(:aki_alert, patient_id: patient.id, created_at: 6.days.ago)

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Renal::AKIAlert, :count).by(0)
            end

            it "assigns the hospital centre found by code in the the MSH" do
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
              create(
                :modality,
                started_on: Date.parse("2015-04-01"),
                patient: patient,
                description: create(:modality_description, :aki)
              )
              hospital_centre = create(:hospital_centre, code: "RAJ01")

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Renal::AKIAlert, :count).by(1)

              aki_alert = Renalware::Renal::AKIAlert.last
              expect(aki_alert).to have_attributes(
                hospital_centre_id: hospital_centre.id
              )
            end

            it "assigns nil to hospital centre when sending_facility in MSH is not a valid hosp" do
              patient = create(:patient, local_patient_id: "Z999990", born_on: "19880924")
              create(
                :modality,
                started_on: Date.parse("2015-04-01"),
                patient: patient,
                description: create(:modality_description, :aki)
              )
              create(:hospital_centre, code: "SOMETOTHER") # so RAJ01 not found

              expect {
                Renalware::Feeds.message_processor.call(raw_message)
              }.to change(Renalware::Renal::AKIAlert, :count).by(1)

              aki_alert = Renalware::Renal::AKIAlert.last
              expect(aki_alert).to have_attributes(
                hospital_centre_id: nil
              )
            end
          end
        end
      end
    end
  end
end
