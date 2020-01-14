# frozen_string_literal: true

require "rails_helper"

module Renalware::HD::Scheduling
  describe DiarySlot, type: :model do
    it_behaves_like "an Accountable model"
    it :aggregate_failures do
      is_expected.to belong_to(:diary).touch(true)
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to belong_to(:station)
      is_expected.to belong_to(:diurnal_period_code)
      is_expected.to validate_presence_of(:diary)
      is_expected.to validate_presence_of(:patient)
      is_expected.to validate_presence_of(:station)
      is_expected.to validate_presence_of(:day_of_week)
      is_expected.to validate_presence_of(:diurnal_period_code)
      is_expected.to validate_inclusion_of(:day_of_week).in_range(1..7)
    end
  end
end
