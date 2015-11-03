require 'rails_helper'

module Renalware
  describe "Ordered Set scope" do
    class ::Qux < ActiveRecord::Base
      include OrderedSetScope
    end

    context "given a relation" do
      before do
        create_relation

        %w(baz bar foo).each do |value|
          Qux.create(code: value)
        end
      end

      context "and the specified values we wish to query with are present in the relation" do
        let(:ordered_values) { %w(foo bar) }

        describe "when querying the relation with the scope" do
          it "returns the set in order of the attribute and values specified" do
            actual_set = Qux.ordered_set(:code, ordered_values)

            expect(actual_set.map(&:code)).to eq(ordered_values)
          end
        end
      end

      context "given the specifed values we wish to query with are not present in the relation" do
        let(:ordered_values) { ["foo;DROP users", "bar"] }

        describe "when querying the relation with the scope" do
          it "return an empty scope" do
            expect(Qux.ordered_set(:code, ordered_values)).to be_empty
          end
        end
      end
    end

    def create_relation
      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :quxes, :force => true do |t|
          t.string :code
        end
      end
    end
  end
end
