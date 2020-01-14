# frozen_string_literal: true

require "rails_helper"

module Renalware::Hospitals
  describe Centre, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:code)
      is_expected.to validate_presence_of(:name)
    end
  end
end
