# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::Observation, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:description)
      is_expected.to validate_presence_of(:result)
      is_expected.to validate_presence_of(:observed_at)
      is_expected.to belong_to(:request).touch(true)
    end
  end
end
