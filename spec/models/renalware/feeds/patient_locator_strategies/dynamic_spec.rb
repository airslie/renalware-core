# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe PatientLocatorStrategies::Dynamic do
    let(:someday) { "2000-01-01" }
    let(:nhs_number_a) { "0909718644" }
    let(:nhs_number_b) { "8844503506" }
    let(:local_patient_id_a) { "123" }
    let(:local_patient_id_b) { "456" }

    describe "#call" do
      subject { described_class.call(patient_identification: pi) }

      context "when patient has an NHS number" do
        context "when patient has a hospital number" do
          it "matches on NHS number and 1 or more hospital number" do
            target_patient = create_patient(
              nhs_number: nhs_number_a,
              local_patient_id: local_patient_id_a,
              born_on: someday
            )
            _other_patient = create_patient(
              nhs_number: nhs_number_b,
              local_patient_id: local_patient_id_b
            )
            pi = create_pi(
              nhs_number: nhs_number_a,
              local_patient_id: local_patient_id_a,
              born_on: someday
            )

            expect(
              described_class.call(patient_identification: pi)
            ).to eq(target_patient)
          end
        end

        context "when patient has no hospital number" do
          it "raises an error if dob missing" do
            pi = create_pi(
              nhs_number: nhs_number_a,
              local_patient_id: nil,
              born_on: nil
            )

            expect {
              described_class.call(patient_identification: pi)
            }.to raise_error(ArgumentError)
          end

          it "matches on NHS number and dob" do
            target_patient = create_patient(nhs_number: nhs_number_a, born_on: someday)
            pi = create_pi(nhs_number: nhs_number_a, born_on: someday)

            expect(
              described_class.call(patient_identification: pi)
            ).to eq(target_patient)
          end
        end
      end

      context "when patient has no NHS number" do
        it "raises an error if dob missing" do
          pi = create_pi(local_patient_id: "ABC", born_on: nil)

          expect {
            described_class.call(patient_identification: pi)
          }.to raise_error(ArgumentError)
        end

        it "raises an error if no hospital numbers" do
          pi = create_pi(local_patient_id: nil, born_on: someday)

          expect {
            described_class.call(patient_identification: pi)
          }.to raise_error(ArgumentError)
        end

        it "matches on hospital number and dob" do
          target_patient = create_patient(local_patient_id: "123", born_on: someday)
          _other_patient = create_patient(local_patient_id: "456", born_on: someday)
          pi = create_pi(local_patient_id: "123", born_on: someday)

          expect(
            described_class.call(patient_identification: pi)
          ).to eq(target_patient)
        end
      end

      def create_pi(born_on: nil, nhs_number: nil, **identifiers)
        identifiers = identifiers.compact_blank
        identifiers[:nhs_number] ||= nhs_number
        instance_double(
          Renalware::Feeds::PatientIdentification,
          born_on: born_on,
          identifiers: identifiers.to_h,
          nhs_number: nhs_number
        )
      end

      def create_patient(born_on: someday, nhs_number: nil, **)
        create(
          :patient,
          nhs_number: nhs_number,
          born_on: born_on,
          **
        )
      end
    end
  end
end
