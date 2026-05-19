# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  # Test class so we can treat the view like a regular AR table
  class TestHeroicParticipants < ApplicationRecord
    self.table_name = "renalware_heroic.heroic_participants"

    def readonly?
      true
    end
  end

  RSpec.describe TestHeroicParticipants do
    describe "#active" do
      subject { described_class.all[0].active }

      context "when the patient is inactive" do
        before { participant = create(:heroic_participation, :inactive) }

        it { is_expected.to be(false) }
      end

      context "when the patient is 3_complete_withdrawal" do
        before { create(:heroic_participation, :complete_withdrawal) }

        it { is_expected.to be(false) }
      end

      context "when the patient is active" do
        before { create(:heroic_participation, :active) }

        it { is_expected.to be(true) }
      end
    end
  end
end
