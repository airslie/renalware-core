# frozen_string_literal: true

require "rails_helper"

module SQL
  describe IndexedCaseStmt do
    describe "#generate" do
      subject { described_class.new(:column, [:HGB, "PLT", "cre"]).generate }

      it {
        is_expected.to eq("CASE column WHEN 'HGB' THEN 0 WHEN 'PLT' THEN 1 WHEN 'cre' THEN 2 END")
      }
    end
  end
end
