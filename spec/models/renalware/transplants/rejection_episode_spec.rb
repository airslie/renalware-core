# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Transplants
    describe RejectionEpisode do
      it_behaves_like "an Accountable model"
      it { is_expected.to be_versioned }
      it { is_expected.to belong_to(:followup).touch(true) }
      it { is_expected.to validate_presence_of(:followup_id) }
      it { is_expected.to validate_presence_of(:recorded_on) }
      it { is_expected.to validate_presence_of(:notes) }
    end
  end
end
