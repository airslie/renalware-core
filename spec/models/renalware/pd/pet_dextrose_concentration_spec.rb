# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe PETDextroseConcentration, type: :model do
      it { is_expected.to validate_presence_of(:name) }

      describe "uniqueness" do
        subject { described_class.new(name: "x", position: 0) }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
