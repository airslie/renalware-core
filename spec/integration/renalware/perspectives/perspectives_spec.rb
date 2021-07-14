# frozen_string_literal: true

require "rails_helper"

describe "Perspectives", type: :system do
  let(:patient) { create(:patient) }

  describe "Viewing patient perspectives", system: true do
    it "Bone" do
      login_as_clinical

      visit patient_bone_perspective_path(patient)

      expect(page).to have_content("Perspectives / Bone")
      expect(page).to have_content("Prescriptions")
      # TODO: check graphs are rendering?
    end

    it "Anaemia" do
      login_as_clinical

      visit patient_anaemia_perspective_path(patient)

      expect(page).to have_content("Perspectives / Anaemia")
      expect(page).to have_content("Prescriptions")
      expect(page).to have_content("Iron Clinic Events")
      # TODO: check graphs are rendering?
    end
  end
end
