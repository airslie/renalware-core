# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Clinical
    describe DryWeight, type: :model do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:assessor)
        is_expected.to validate_presence_of(:weight)
        is_expected.to validate_presence_of(:assessed_on)
        is_expected.to validate_timeliness_of(:assessed_on)
        is_expected.to belong_to(:patient).touch(true)
      end
    end
  end
end
