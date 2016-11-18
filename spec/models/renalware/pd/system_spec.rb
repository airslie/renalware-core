require "rails_helper"

module Renalware
  module PD
    RSpec.describe System, type: :model do
      it { should validate_presence_of :name }
      it { should validate_presence_of :pd_type }

      describe "#for_apd" do
        it "only returns apd systems" do
          create(:capd_system)
          apd_system = create(:apd_system)
          expect(System.for_apd).to eq [apd_system]
        end
      end

      describe "#for_capd" do
        it "only returns capd systems" do
          capd_system = create(:capd_system)
          create(:apd_system)
          expect(System.for_capd).to eq [capd_system]
        end
      end
    end
  end
end
