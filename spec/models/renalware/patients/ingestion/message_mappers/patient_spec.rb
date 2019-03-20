# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    module Ingestion
      describe MessageMappers::Patient do
        let(:message) {
          double(
            :message,
            type: "A123",
            patient_date_time_of_birth: "19600101000000",
            patient_date_time_of_death: "20010101000000",
            practice_code: "E81010",
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
              death_date: " 01-01-2001"
            )
          )
        }

        subject { described_class.new(message) }

        it "maps a message to a patient" do
          actual = subject.fetch

          expect(actual.local_patient_id).to eq(message.patient_identification.internal_id)
          expect(actual.nhs_number.to_s).to eq(message.patient_identification.external_id)
          expect(actual.given_name).to eq(message.patient_identification.given_name)
          expect(actual.family_name).to eq(message.patient_identification.family_name)
          # expect(actual.middle_name).to eq(message.patient_middle_initial_or_name)
          expect(actual.suffix).to eq(message.patient_identification.suffix)
          expect(actual.title).to eq(message.patient_identification.title)
          expect(actual.sex.code).to eq(message.patient_identification.sex)
          expect(actual.born_on).to eq(Date.parse("01-01-1960"))
          expect(actual.died_on).to eq(Time.zone.parse("01-01-2001"))

          # expect(actual.practice_code).to eq(message.practice_code)
          # expect(actual.gp_code).to eq(message.gp_code)
        end
      end
    end
  end
end
