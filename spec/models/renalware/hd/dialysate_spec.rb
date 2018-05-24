# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe Dialysate, type: :model do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:sodium_content) }
      it { is_expected.to validate_numericality_of(:sodium_content) }
      it { is_expected.to validate_presence_of(:sodium_content_uom) }
      it { is_expected.to validate_numericality_of(:bicarbonate_content) }
      it { is_expected.to validate_numericality_of(:calcium_content) }
      it { is_expected.to validate_numericality_of(:glucose_content) }
      it { is_expected.to validate_numericality_of(:potassium_content) }

      it_behaves_like "a Paranoid model"

      describe "uniqueness" do
        subject { described_class.new(name: "x", sodium_content: 1, sodium_content_uom: "mmol/L") }

        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end
  end
end
