require "rails_helper"

module Renalware
  RSpec.describe Renal::AKIAlertAction, type: :model do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to have_db_index(:name) }

    describe "uniqueness" do
      subject { described_class.new(name: "X") }
      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
