require "rails_helper"

module Renalware
  RSpec.describe Research::Study, type: :model do
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to have_db_index(:code) }
    it { is_expected.to have_db_index(:description) }
    it { is_expected.to respond_to(:by=) } # accountable

    it "is paranoid" do
      expect(described_class).to respond_to(:deleted)
    end
  end
end
