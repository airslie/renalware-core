# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Patients
    RSpec.describe ClearPatientUKRDCData do
      describe "#call" do
        it "clears the RPV status if the modality description type is death" do
          travel_to(Time.zone.now) do
            patient = create(:patient, send_to_rpv: true, rpv_decision_on: 1.year.ago)
            user = create(:user)

            described_class.call(patient: patient, by: user)

            expect(patient.send_to_rpv).to eq(false)
            expect(patient.rpv_decision_on).to eq(Time.zone.today)
            expect(patient.rpv_recorded_by).to eq(user.to_s)
          end
        end
      end
    end
  end
end
