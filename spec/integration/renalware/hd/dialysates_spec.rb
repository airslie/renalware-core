# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Managing Dialysates", type: :system do
  let(:dialysate) { create(:hd_dialysate) }

  describe "creating a new dialysate" do
    it do
      login_as_super_admin

      visit root_path

      within ".top-bar" do
        click_on "Super Admin"
        click_on "HD Dialysates"
      end

      click_on "Add"

      fill_in "Name", with: "a name"
      fill_in "Description", with: "a description"
      fill_in "dialysate[sodium_content]", with: "111"
      fill_in "Sodium content uom", with: "mmol/L"
      fill_in "dialysate[bicarbonate_content]", with: "222.2"
      fill_in "Bicarbonate content uom", with: "mmol/L"
      fill_in "dialysate[calcium_content]", with: "333.3"
      fill_in "Calcium content uom", with: "mmol/L"
      fill_in "dialysate[potassium_content]", with: "444.4"
      fill_in "Potassium content uom", with: "mmol/L"

      click_on "Create"

      within ".hd-dialysates tbody" do
        expect(page).to have_content("a name")
        expect(page).to have_content("a description")
        expect(page).to have_content("111 mmol/L")
        expect(page).to have_content("222.2 mmol/L")
        expect(page).to have_content("333.3 mmol/L")
        expect(page).to have_content("444.4 mmol/L")
      end
    end
  end

  describe "editing a dialysate" do
    it do
      create(:hd_dialysate)

      login_as_super_admin
      visit hd_dialysates_path

      within ".hd-dialysates tbody" do
        click_on "Edit"
      end

      fill_in "Name", with: "a new name"
      fill_in "Description", with: "a new description"
      click_on "Save"

      within ".hd-dialysates tbody" do
        expect(page).to have_content("a new name")
        expect(page).to have_content("a new description")
      end
    end
  end

  # Temp removed this test as need to fix deletion - it currently allows deletion of
  # in-use dialysates.
  # There is also the problem that if you change the name the dialysate wont load
  # up as the patents default in the hd_profile

  # describe "deleting a dialysate" do
  #   it do
  #     dialysate = create(:hd_dialysate, name: "XYZ")

  #     login_as_super_admin
  #     visit hd_dialysates_path

  #     within ".hd-dialysates tbody" do
  #       click_on "Delete"
  #     end

  #     within ".hd-dialysates tbody" do
  #       expect(page).not_to have_content("XYZ")
  #     end
  #   end
  # end
end
