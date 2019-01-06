# frozen_string_literal: true

require "rails_helper"

module Renalware::Pathology
  describe MeasurementUnit do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_many(:observation_descriptions) }
  end
end
