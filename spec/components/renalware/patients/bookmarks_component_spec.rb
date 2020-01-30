# frozen_string_literal: true

require "rails_helper"

describe Renalware::Patients::BookmarksComponent, type: :component do
  context "when a user has bookmarks" do
    it "displays the user's bookmarks" do 
      user = create(:patients_user)
      patient = create(:patient, by: user)
      bookmark = create(:patients_bookmark, user: user, patient: patient)
    
      html = render_inline(described_class, current_user: user).to_html

      expect(html).to match("Bookmarked Patients")
      expect(html).to match(patient.to_s)
    end
  end

  context "when a user has no bookmarks" do
    it "displays a no bookmarks message" do
      user = create(:patients_user)

      html = render_inline(described_class, current_user: user).to_html

      expect(html).to match("Bookmarked Patients")
      expect(html).to match("There are no patients bookmarked.")
    end
  end
end
