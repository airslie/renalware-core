require "rails_helper"

module Renalware
  RSpec.describe Research::StudyParticipant, type: :model do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of :participant_id }
  end
end
