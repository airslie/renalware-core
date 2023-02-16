# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Delivery::TransferOfCare
  describe Sections::InformationAndAdviceGivenComponent, type: :component do
    it do
      letter = nil
      render_inline(described_class.new(letter))

      expect(page).to have_content("InformationAndAdviceGivenComponent")
    end
  end
end
