require "rails_helper"

module Renalware
  RSpec.describe Pathology::Observation, type: :model do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:result) }
    it { is_expected.to validate_presence_of(:observed_at) }
  end
end
