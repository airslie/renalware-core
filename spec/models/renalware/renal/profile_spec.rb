require "rails_helper"

module Renalware
  RSpec.describe Renal::Profile, type: :model do
    it { should validate_presence_of :patient }
    it { should validate_presence_of :diagnosed_on }

    it { is_expected.to validate_timeliness_of(:diagnosed_on) }
  end
end
