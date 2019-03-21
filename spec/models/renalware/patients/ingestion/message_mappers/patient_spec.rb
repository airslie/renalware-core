# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    module Ingestion
      describe MessageMappers::Patient do
        subject { described_class.new(message) }

        let(:primary_care_physician) { build_stubbed(:primary_care_physician) }
        let(:practice) { build_stubbed(:practice) }
        let(:message) {
          double(
            :message,
            type: "A123",
            patient_date_time_of_birth: "19600101000000",
            patient_date_time_of_death: "20010101000000",
            practice_code: "P1234567",
            gp_code: "G9803006",
            patient_identification: double(
              :patient_dentification,
              internal_id: "1",
              external_id: "2",
              given_name: "Roger",
              family_name: "Rabbit",
              suffix: "Jr.",
              title: "Mr",
              sex: "M",
              dob: "01-01-1960",
              death_date: " 01-01-2001",
              address: %w(street1 street2 town county postcode)
            )
          )
        }

        it "maps a message to a patient" do
          stub_primary_care_physician_find
          stub_practice_find

          actual = subject.fetch

          expect(actual).to have_attributes(
            local_patient_id: message.patient_identification.internal_id,
            nhs_number: message.patient_identification.external_id,
            given_name: message.patient_identification.given_name,
            family_name: message.patient_identification.family_name,
            suffix: message.patient_identification.suffix,
            title: message.patient_identification.title,
            born_on: Date.parse("01-01-1960"),
            died_on: Time.zone.parse("01-01-2001"),
            primary_care_physician: primary_care_physician,
            practice: practice
          )
          expect(actual.sex.code).to eq(message.patient_identification.sex)

          expect(actual.current_address).to have_attributes(
            street_1: "street1",
            street_2: "street2",
            street_3: nil,
            town: "town",
            county: "county",
            postcode: "postcode"
          )
        end

        def stub_primary_care_physician_find
          allow(
            Renalware::Patients::PrimaryCarePhysician
          ).to receive(:find_by).and_return(primary_care_physician)
        end

        def stub_practice_find
          allow(
            Renalware::Patients::Practice
          ).to receive(:find_by).and_return(practice)
        end
      end
    end
  end
end
