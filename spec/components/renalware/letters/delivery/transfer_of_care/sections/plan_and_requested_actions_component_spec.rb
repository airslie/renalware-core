# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Sections::PlanAndRequestedActionsComponent, type: :component do
    it do
      letter = nil
      render_inline(described_class.new(letter))

      expect(page).to have_content("PlanAndRequestedActionsComponent")
    end
  end
end
