# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Accesses
    describe Assessment do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to validate_presence_of(:type)
        is_expected.to validate_presence_of(:side)
        is_expected.to validate_presence_of(:performed_on)
        is_expected.to validate_timeliness_of(:performed_on)
        is_expected.to validate_timeliness_of(:procedure_on)
        is_expected.to belong_to(:patient).touch(true)
      end
    end
  end
end
