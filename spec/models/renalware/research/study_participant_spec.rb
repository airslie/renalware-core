require "rails_helper"
require_dependency "models/renalware/concerns/accountable"

module Renalware
  RSpec.describe Research::StudyParticipant, type: :model do
    it_behaves_like "Accountable"
    it { is_expected.to validate_presence_of :participant_id }

    it "is paranoid" do
      expect(described_class).to respond_to(:deleted)
    end
  end
end
