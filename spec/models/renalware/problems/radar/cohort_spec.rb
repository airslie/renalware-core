# frozen_string_literal: true

require "rails_helper"

module Renalware::Problems::RaDaR
  describe Cohort do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_index(:name) }
    it { is_expected.to have_many(:diagnoses) }
  end
end
