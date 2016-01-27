require 'rails_helper'

module Renalware
  describe Role, type: :model do
    it { should have_and_belong_to_many :users }

    describe ".fetch" do
      context "given an empty collection of id's" do
        it "returns none" do
          expect(Role.fetch([])).to be_empty
        end
      end

      context "given a collection of id's" do
        let!(:role) { create(:role, name: "fake_role") }

        it "returns the specified roles" do
          expect(Role.fetch([role.id]).map(&:name)).to include("fake_role")
        end
      end
    end
  end
end
