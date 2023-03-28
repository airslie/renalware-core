# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Drugs::DMD
    describe SynchroniserJob do
      describe "#perform_now" do
        let(:synchroniser) { instance_double Synchronisers::FullSynchroniser, call: nil }

        before do
          allow(Synchronisers::FullSynchroniser).to receive(:new).and_return(synchroniser)
        end

        it "calls the full synchroniser" do
          described_class.perform_now
          expect(synchroniser).to have_received(:call)
        end
      end
    end
  end
end
