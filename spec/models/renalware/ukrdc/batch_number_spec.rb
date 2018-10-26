# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::BatchNumber do
    describe ".next" do
      subject { described_class.next }

      it "creates a new row" do
        expect{ subject }.to change(described_class, :count).by(1)
      end

      it { expect(subject.length).to eq(6) }
      it { is_expected.to match(/0+\d+/) }
    end
  end
end
