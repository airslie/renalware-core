require "rails_helper"

module Renalware::Letters
  describe Part::CurrentMedications do
    let(:patient) { double(:patient, medications: [:medication]) }
    subject(:current_medications_part) { Part::CurrentMedications.new(patient) }

    it "delegates to the patient's current medications"do
      expect(current_medications_part.to_a).to match([:medication])
    end
  end
end
