# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Renal::Profile, type: :model do
    it { is_expected.to belong_to(:patient).touch(true) }
    it { is_expected.to validate_presence_of :patient }

    it { is_expected.to validate_timeliness_of(:esrf_on) }
    it { is_expected.to validate_timeliness_of(:first_seen_on) }
    it { is_expected.to validate_timeliness_of(:comorbidities_updated_on) }
  end
end
