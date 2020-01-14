# frozen_string_literal: true

require "rails_helper"

module Renalware::Feeds
  describe File do
    subject { Renalware::Feeds::File.new }

    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to validate_presence_of(:location)
      is_expected.to validate_presence_of(:status)
      is_expected.to respond_to(:by=)
      is_expected.to belong_to(:file_type)
    end
  end
end
