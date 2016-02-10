require "rails_helper"

module Renalware
  module HD
    RSpec.describe DryWeight, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:assessor) }
      it { is_expected.to validate_presence_of(:weight) }
      it { is_expected.to validate_presence_of(:assessed_on) }
      it { is_expected.to validate_timeliness_of(:assessed_on) }
    end
  end
end
