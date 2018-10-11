# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe PatientPathologyScopes do
      describe "class methods" do
        describe "#pathology_result_sort_predicate" do
          it "creates a SQL coalesce stateument that will map null results as -1" do
            expect(
              described_class.pathology_result_sort_predicate(:HGB)
            ).to eq("coalesce(convert_to_float(values -> 'HGB' ->> 'result'), -1)")
          end
        end

        describe "#pathology_date_sort_predicate(column)" do
          it "creats a SQL statement to cast the column as a date so sorting is consistent" do
            expect(
              described_class.pathology_date_sort_predicate(:HGB)
            ).to eq "cast(values -> 'HGB' ->> 'observed_at' as date)"
          end
        end
      end
    end
  end
end
