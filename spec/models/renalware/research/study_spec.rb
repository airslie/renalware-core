# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Research::Study, type: :model do
    it :aggregate_failures do
      is_expected.to validate_presence_of :code
      is_expected.to validate_presence_of :description
      is_expected.to have_db_index(:code)
      is_expected.to have_db_index(:description)
    end

    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
  end
end
