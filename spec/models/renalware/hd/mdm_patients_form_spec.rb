# frozen_string_literal: true

require "rails_helper"

module Renalware::HD
  RSpec.describe MDMPatientsForm, type: :model do
    describe "#options" do
      describe "hospital_unit_id" do
        it "maps to a ransack predicate" do
          options = described_class.new(hospital_unit_id: 1).options
          expect(options[:hospital_unit_id_eq]).to eq(1)
        end
      end

      describe "schedule" do
        context "when a schedule definition id eg 'M T W am' was chosen" do
          it "maps to a ransack predicate so we can query for patients having the matching "\
             "schedule definition" do
            options = described_class.new(schedule: "1").options
            expect(options[:schedule_definition_id_eq]).to eq(1)
          end
        end

        context "when a named filter is passed" do
          describe "any_mtw" do
            it "maps to a ransack predicate" do
              options = described_class.new(schedule: "any_mtw").options
              expect(options[:schedule_definition_id_in]).to eq([1, 2, 3])
            end
          end
        end
      end
    end
  end
end
