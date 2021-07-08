# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Events::Subtype, type: :model do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to be_versioned
      is_expected.to belong_to :event_type
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:event_type_id)
      is_expected.to validate_presence_of(:definition)
    end
  end
end
