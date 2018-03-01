# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe Part::Problems do
    subject(:part) { Part::Problems.new(patient, Letter.new) }

    let(:patient) { spy(:patient) }

    it "delegates to the patient's current problems" do
      part.to_a

      expect(patient).to have_received(:problems)
    end
  end
end
