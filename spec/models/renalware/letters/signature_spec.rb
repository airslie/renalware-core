# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Signature, type: :model do
      it { is_expected.to validate_presence_of(:user) }
      it { is_expected.to validate_presence_of(:letter) }
      it { is_expected.to validate_presence_of(:signed_at) }
      it { is_expected.to belong_to(:user).touch(true) }
      it { is_expected.to belong_to(:letter).touch(true) }

      describe "#to_s" do
        subject(:signature) { Signature.new(user: user, signed_at: "2016-08-01 12:05:55") }

        let(:user) { build(:user, family_name: "Doe", given_name: "John") }

        it "returns a signature line" do
          expect(signature.to_s).to eq("ELECTRONICALLY SIGNED BY JOHN DOE AT 12:05 ON 01-AUG-2016")
        end
      end
    end
  end
end
