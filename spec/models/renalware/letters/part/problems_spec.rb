require "rails_helper"

module Renalware::Letters
  describe Part::Problems do
    let(:patient) { double(:patient, problems: [:problem]) }
    let(:event) { nil }
    subject(:part) { Part::Problems.new(patient, event) }

    it "delegates to the patient's current medications"do
      expect(part.to_a).to match([:problem])
    end
  end
end
