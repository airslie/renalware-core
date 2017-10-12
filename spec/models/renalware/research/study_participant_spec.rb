require "rails_helper"

module Renalware
  RSpec.describe Research::StudyParticipant, type: :model do
    it { is_expected.to validate_presence_of :participant_id }
    it { is_expected.to respond_to(:by=) } # accountable

    it "is paranoid" do
      expect(described_class).to respond_to(:deleted)
    end
  end
end
