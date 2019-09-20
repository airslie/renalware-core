# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Batch, type: :model do
      include LettersSpecHelper
      it { is_expected.to have_many :items }
      it { is_expected.to have_many(:letters).through(:items) }

      describe "#status" do
        it "defaults to queued" do
          user = create(:user)
          batch = described_class.create!(by: user).reload
          expect(batch.queued?).to eq(true)
          expect(batch.processing?).to eq(false)
          expect(batch.failure?).to eq(false)
          expect(batch.success?).to eq(false)
        end
      end

      describe "#letters" do
        it "returns letters added to the batch" do
          user = create(:user)
          letter = create_letter(
            state: :approved,
            to: :patient,
            patient: create(:letter_patient)
          )
          batch = described_class.create!(by: user)
          batch.items.create(letter: letter)

          batch.reload
          expect(batch.letters.count).to eq(1)
          expect(batch.items.count).to eq(1)
        end
      end
    end
  end
end
