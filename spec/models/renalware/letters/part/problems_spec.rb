require "rails_helper"

module Renalware::Letters
  describe Part::Problems do
    let(:patient) { spy(:patient) }
    subject(:part) { Part::Problems.new(patient) }

    it "delegates to the patient's current problems" do
      part.to_a

      expect(patient).to have_received(:problems)
    end
  end
end
