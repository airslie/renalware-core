describe Renalware::Patients::BookmarksComponent, type: :component do
  context "when a user has bookmarks" do
    it "displays the user's bookmarks" do
      user = create(:patients_user)
      patient = create(:patient, by: user)
      create(:patients_bookmark, user:, patient:)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_text("Bookmarked Patients")
      expect(page).to have_text(patient.to_s)
    end

    it "does not display bookmarks for merged patients" do
      user = create(:patients_user)
      active_patient = create(:patient, by: user, given_name: "Active")
      merged_patient = create(:patient, by: user, given_name: "Merged", merged_at: Time.zone.now)
      create(:patients_bookmark, user:, patient: active_patient)
      create(:patients_bookmark, user:, patient: merged_patient)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_text(active_patient.to_s)
      expect(page).to have_no_text(merged_patient.to_s)
    end
  end

  context "when a user has no bookmarks" do
    it "displays a no bookmarks message" do
      user = build_stubbed(:patients_user)

      render_inline(described_class.new(current_user: user))

      expect(page).to have_text("Bookmarked Patients")
      expect(page).to have_text("There are no patients bookmarked")
    end
  end
end
