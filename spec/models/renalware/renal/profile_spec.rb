require "rails_helper"

module Renalware
  RSpec.describe Renal::Profile, type: :model do
    it { should validate_presence_of :patient }

    it { is_expected.to validate_timeliness_of(:esrf_on) }
    it { is_expected.to validate_timeliness_of(:first_seen_on) }
  end
end
