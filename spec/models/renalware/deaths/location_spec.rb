# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Deaths
    describe Location, type: :model do
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of(:name) }

      describe "uniqueness" do
        subject { described_class.new(name: "Other") }

        it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
      end
    end
  end
end
