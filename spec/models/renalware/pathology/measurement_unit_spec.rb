# frozen_string_literal: true

require "rails_helper"

module Renalware::Pathology
  describe MeasurementUnit do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:name)
      is_expected.to have_many(:observation_descriptions)
    end
  end
end
