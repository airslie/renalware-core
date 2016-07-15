require "rails_helper"

module Renalware::Letters
  describe Part::CurrentPrescriptions do
    let(:patient) { double(:patient, prescriptions: [:prescription]) }
    subject(:current_prescriptions_part) { Part::CurrentPrescriptions.new(patient) }

    it "delegates to the patient's current prescriptions"do
      expect(current_prescriptions_part.to_a).to match([:prescription])
    end
  end
end
