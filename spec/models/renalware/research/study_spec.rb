require "rails_helper"
require_dependency "models/renalware/concerns/accountable"

module Renalware
  RSpec.describe Research::Study, type: :model do
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to have_db_index(:code) }
    it { is_expected.to have_db_index(:description) }
    it_behaves_like "Accountable"

    it "is paranoid" do
      expect(described_class).to respond_to(:deleted)
    end
  end
end
