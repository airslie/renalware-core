# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe Classification, type: :model do
    it :aggregate_failures do
      is_expected.to belong_to(:drug).touch(true)
      is_expected.to belong_to(:drug_type)
    end
  end
end
