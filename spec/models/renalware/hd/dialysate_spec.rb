require "rails_helper"

module Renalware
  module HD
    describe Dialysate, type: :model do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:sodium_content) }
      it { is_expected.to validate_presence_of(:sodium_content_uom) }
      it { is_expected.to have_db_index(:deleted_at) }

      describe "uniqueness" do
        subject { described_class.new(name: "x", sodium_content: 1, sodium_content_uom: "mmol/L") }
        it { is_expected.to validate_uniqueness_of(:name) }
      end

      it "is paranoid" do
        expect(described_class).to respond_to(:deleted)
      end
    end
  end
end
