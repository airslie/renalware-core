# frozen_string_literal: true

module Renalware
  RSpec.describe Events::Detail::AdvancedCarePlan do
    subject { described_class.new(record) }

    let(:record) { Events::AdvancedCarePlan.new(document: { state: :not_required }) }

    it "renders component" do
      expect(fragment.text).to include("State:Not required")
      expect(fragment.text).to include("Notes:Not specified")
    end
  end
end
