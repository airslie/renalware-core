# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe BatchItem, type: :model do
      it :aggregate_failures do
        is_expected.to belong_to :letter
        is_expected.to belong_to :batch
      end
    end
  end
end
