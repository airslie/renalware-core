# frozen_string_literal: true

require "rails_helper"

describe Renalware::Letters::UnreadElectronicCCsComponent, type: :component do
  include LettersSpecHelper

  def send_letter_ecc_to(user)
    author = create(:user)
    patient = create(:letter_patient)
    letter = create_letter(state: :approved, to: :patient, patient: patient, by: author)
    letter.electronic_cc_recipients << user
    letter.save_by!(author)
    letter
  end

  context "when a user has unread eCCs" do
    it "displays the user's eCCs" do
      user = create(:user)
      letter = send_letter_ecc_to(user)

      html = render_inline(described_class, current_user: user).to_html

      expect(html).to match("Electronic CCs")
      expect(html).to match(letter.description)
    end
  end

  context "when a user has no eCCs" do
    it "displays a no messages message" do
      user = create(:user)

      html = render_inline(described_class, current_user: user).to_html

      expect(html).to match("Electronic CCs")
      expect(html).to match("You have no electronic CCs")
    end
  end
end
