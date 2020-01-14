# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe Type, type: :model do
    it :aggregate_failures do
      is_expected.to have_many(:classifications)
      is_expected.to have_many(:drugs).through(:classifications)
    end
  end
end
