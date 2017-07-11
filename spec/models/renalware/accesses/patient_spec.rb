require "rails_helper"

module Renalware::Accesses
  RSpec.describe Patient, type: :model do
    it { is_expected.to have_many(:profiles) }
    it { is_expected.to have_many(:plans) }
    it { is_expected.to have_many(:procedures) }
    it { is_expected.to have_many(:assessments) }

    describe "current_plan" do
      it "returns the current plan" do
        patient = create(:accesses_patient)
        current_plan = create(:access_plan, patient: patient)
        create(:access_plan, patient: patient, terminated_at: Time.zone.now)

        expect(patient.current_plan).to eq(current_plan)
      end
    end
  end
end
