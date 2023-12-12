# frozen_string_literal: true

require "rails_helper"

module Renalware
  module System
    describe Role do
      it { is_expected.to validate_uniqueness_of(:name) }

      describe ".fetch" do
        context "with an empty collection of id's" do
          it "returns none" do
            expect(described_class.fetch([])).to be_empty
          end
        end

        context "with a collection of id's" do
          let!(:role) { create(:role, name: "fake_role") }

          it "returns the specified roles" do
            expect(described_class.fetch([role.id]).map(&:name)).to include("fake_role")
          end
        end
      end

      describe "::enforce?" do
        it "returns true or false according to the role#enforce column" do
          r1 = Role.create!(name: "r1", enforce: true)
          _r2 = Role.create!(name: "r2", enforce: false)

          expect(Role.role_enforcement_hash).to eq({ "r1" => true, "r2" => false })
          expect(Role.enforce?(:r1)).to be(true)
          expect(Role.enforce?(:r2)).to be(false)

          # Changing the enforce boolean will be reflected without a restart as we memoise at
          # class level on first access.
          r1.update!(enforce: false)
          expect(Role.enforce?(:r1)).to be(false)
        end
      end
    end
  end
end
