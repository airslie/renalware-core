# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::Observation, type: :model do
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:result) }
    it { is_expected.to validate_presence_of(:observed_at) }
    it { is_expected.to belong_to(:request).touch(true) }
  end
end
