# frozen_string_literal: true

require "rails_helper"

describe Renalware::Letters::LettersInProgressComponent, type: :component do
  include LettersSpecHelper

  context "when the user has no letters in progress" do 
    it "displays a message saying as much" do 
      user = create(:user)
      
      html = render_inline(described_class, user: user).to_html

      expect(html).to match("Letters in Progress")
    end
  end

  context "when the user has letters in progress" do 
    it "displays them" do 
      user = create(:user)
      patient = create(:letter_patient)
      letter = create_letter(state: :draft, to: :patient, patient: patient, by: user)
      
      html = render_inline(described_class, user: user).to_html

      expect(html).to match("Letters in Progress")
    end
  end
end