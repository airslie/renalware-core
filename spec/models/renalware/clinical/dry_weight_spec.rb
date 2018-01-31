require "rails_helper"

module Renalware
  module Clinical
    RSpec.describe DryWeight, type: :model do
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:assessor) }
      it { is_expected.to validate_presence_of(:weight) }
      it { is_expected.to validate_presence_of(:assessed_on) }
      it { is_expected.to validate_timeliness_of(:assessed_on) }
      it { is_expected.to belong_to(:patient).touch(true) }
    end
  end
end
