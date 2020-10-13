# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::MeasurementUnit do
    it :aggregate_failures do
      is_expected.to respond_to(:name)
      is_expected.to respond_to(:description)
      is_expected.to validate_presence_of(:name)
    end
  end
end
