require "rails_helper"

module Renalware
  module PD
    describe RegimePolicy, type: :policy do
      let(:admin) { create(:user, :admin) }
      subject { described_class }

      permissions :edit? do
        it "is permitted if the regime is current" do
          regime = Regime.new
          allow(regime).to receive(:current?).and_return(true)
          expect(subject).to permit(admin, regime)
        end

        it "is not permitted if the regime is not current" do
          regime = Regime.new
          allow(regime).to receive(:current?).and_return(false)
          expect(subject).to_not permit(admin, regime)
        end
      end
    end
  end
end
