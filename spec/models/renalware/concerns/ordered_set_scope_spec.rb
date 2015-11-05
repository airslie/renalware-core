require "rails_helper"

module Renalware
  describe "Ordered Set scope" do
    class ::Qux < ActiveRecord::Base
      include OrderedSetScope
    end

    describe "#ordered_set" do
      before do
        create_relation

        %w(baz bar foo).each do |value|
          Qux.create(code: value)
        end
      end

      context "given the specified values present in the relation" do
        let(:ordered_values) { %w(foo bar) }

        it "returns an ordered scope with the attribute and values specified" do
          attribute = :code
          actual_scope = Qux.ordered_set(attribute, ordered_values)

          expect(actual_scope).to be_a ActiveRecord::Relation
          expect(actual_scope.map(&:code)).to eq(ordered_values)
        end
      end

      context "given the values not present in the relation for the specified attribute" do
        let(:ordered_values) { ["foo", "::does not exists::", "bar"] }

        it "returns an ordered scope with the values that exist in the relation"  do
          attribute = :code
          actual_scope = Qux.ordered_set(attribute, ordered_values)

          expect(actual_scope).to be_a ActiveRecord::Relation
          expect(actual_scope.map(&:code)).to eq(%w(foo bar))
        end
      end
    end

    def create_relation
      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :quxes, force: true do |t|
          t.string :code
        end
      end
    end
  end
end
