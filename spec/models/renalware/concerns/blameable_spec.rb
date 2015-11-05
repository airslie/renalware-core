require "rails_helper"

module Renalware
  describe Blameable do
    class ::Qux < ActiveRecord::Base
      include Blameable
    end

    let(:created_by_user) { create(:user) }

    before do
      create_relation
    end

    describe "#create" do
      context "given the created user is explicity assigned" do
        it "assigns the user who created the record" do
          subject = Qux.create!(created_by: created_by_user, dummy: ":: created it ::")

          expect(subject.created_by).to eq(created_by_user)
          expect(subject.updated_by).to eq(created_by_user)
        end
      end

      context "given the user is implicity assigned" do
        before do
          PaperTrail.whodunnit = created_by_user.id
        end

        it "assigns the user who created the record" do
          subject = Qux.create!(dummy: ":: created it ::")

          expect(subject.created_by).to eq(created_by_user)
          expect(subject.updated_by).to eq(created_by_user)
        end
      end
    end

    describe "#updated_by" do
      let(:updated_by_user) { create(:user) }

      subject! { Qux.create!(created_by: created_by_user, dummy: ":: created it ::") }

      context "given the updated user is explicity assigned" do
        it "assigns the user who updated the record" do
          subject.update(updated_by: updated_by_user, dummy: ":: updated_it ::")

          expect(subject.updated_by).to eq(updated_by_user)
        end
      end

      context "given the updated user is implicity assigned" do
        it "assigns the user who updated the record" do
          PaperTrail.whodunnit = created_by_user.id
          subject = Qux.create!(dummy: ":: created it ::")
          PaperTrail.whodunnit = updated_by_user.id
          subject.update(dummy: ":: updated_it ::")

          expect(subject.updated_by).to eq(updated_by_user)
        end
      end
    end

    def create_relation
      ActiveRecord::Schema.define do
        self.verbose = false

        create_table :quxes, force: true do |t|
          t.string :dummy, null: false
          t.integer :created_by_id, null: false
          t.integer :updated_by_id, null: false
        end
      end
    end
  end
end
