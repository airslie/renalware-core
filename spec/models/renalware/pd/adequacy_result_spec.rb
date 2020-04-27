# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe AdequacyResult, type: :model do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to validate_presence_of(:performed_on)
      end
    end
  end
end
