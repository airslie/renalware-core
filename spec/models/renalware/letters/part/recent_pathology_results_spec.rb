require "rails_helper"

module Renalware::Letters
  describe Part::RecentPathologyResults do
    let(:view_current_observation_results) { double(:view_current_observation_results, call: [:result]) }
    let(:patient) { double(:patient) }
    subject(:recent_pathology_results_part) { Part::RecentPathologyResults.new(patient, service: view_current_observation_results) }

    it "delegates to the service"do
      expect(recent_pathology_results_part.to_a).to match([:result])
    end
  end
end
