# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe Part::Problems do
    it "delegates to the patient's current problems" do
      patient = instance_double(Renalware::Patient)
      allow(patient).to receive(:problems).and_return(Renalware::Problems::Problem.none)
      part = Part::Problems.new(patient, Letter.new)

      part.to_a

      expect(patient).to have_received(:problems)
    end
  end
end
