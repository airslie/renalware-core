require "rails_helper"

module Renalware::Letters
  describe Part::Problems do
    let(:patient) { double(:patient, problems: [:problem]) }
    subject(:part) { Part::Problems.new(patient) }

    it "delegates to the patient's current medications"do
      expect(part.to_a).to match([:problem])
    end
  end
end
