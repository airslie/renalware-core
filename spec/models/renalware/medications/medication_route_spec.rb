# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    describe MedicationRoute, type: :model do
      subject(:route) { described_class.new }

      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to have_db_index(:code).unique(true) }

      describe "#other?" do
        it "case-insenstively matches the code 'other'" do
          expect(described_class.new(code: "other").other?).to eq(true)
          expect(described_class.new(code: "OTHER").other?).to eq(true)
        end
      end
    end
  end
end
