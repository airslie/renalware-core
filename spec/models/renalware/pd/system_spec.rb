# frozen_string_literal: true

require "rails_helper"

module Renalware
  RSpec.describe PD::System, type: :model do
    it_behaves_like "a Paranoid model"

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :pd_type }

    describe "#for_apd" do
      it "only returns apd systems" do
        create(:capd_system)
        apd_system = create(:apd_system)
        expect(Renalware::PD::System.for_apd).to eq [apd_system]
      end
    end

    describe "#for_capd" do
      it "only returns capd systems" do
        capd_system = create(:capd_system)
        create(:apd_system)
        expect(Renalware::PD::System.for_capd).to eq [capd_system]
      end
    end
  end
end
