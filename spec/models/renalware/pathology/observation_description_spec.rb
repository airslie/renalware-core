# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::ObservationDescription, type: :model do
    it { is_expected.to belong_to(:measurement_unit) }
    it { is_expected.to have_db_index(:code).unique(true) }
    it { is_expected.to have_many(:code_group_memberships) }
    it { is_expected.to have_many(:code_groups).through(:code_group_memberships) }

    describe "#rr_type enum" do
      it "defaults to 0 (simple)" do
        expect(described_class.new.rr_type).to eq("rr_type_simple")
      end
    end

    describe "#rr_coding_standard enum" do
      it "defaults to 0 (ukrr)" do
        expect(described_class.new.rr_coding_standard).to eq("ukrr")
      end
    end
  end
end
