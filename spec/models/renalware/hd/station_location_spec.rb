require "rails_helper"

module Renalware::HD
  RSpec.describe StationLocation, type: :model do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:colour) }
    it { is_expected.to have_db_index(:name) }

    describe "#name uniqueness" do
      subject { described_class.new(name: "Antechamber", colour: "red") }

      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
