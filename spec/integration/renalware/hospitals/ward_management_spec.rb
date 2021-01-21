# frozen_string_literal: true

require "rails_helper"

describe "Ward Management", type: :system do
  it "displays a list of wards for a hospital" do
    login_as_clinical
    unit = create(:hospital_unit)
    create(:hospital_ward, name: "WardA", hospital_unit: unit)
    create(:hospital_ward, name: "WardB", hospital_unit: unit)

    visit hospitals_unit_wards_path(unit.id)

    expect(page).to have_http_status(:success)
    expect(page).to have_content("WardA")
    expect(page).to have_content("WardB")
  end

  it "edit a ward" do
    login_as_super_admin
    unit = create(:hospital_unit)
    create(:hospital_ward, name: "Name", code: "Code", hospital_unit: unit)

    visit hospitals_unit_wards_path(unit.id)

    within ".hospital-wards" do
      click_on "Edit"
    end

    fill_in "Code", with: "NewCode"
    fill_in "Name", with: "NewName"
    click_on "Save"

    within ".hospital-wards" do
      expect(page).to have_content("NewCode")
      expect(page).to have_content("NewName")
    end
  end

  it "add a ward" do
    login_as_super_admin
    unit = create(:hospital_unit)

    visit hospitals_unit_wards_path(unit.id)

    within ".page-actions" do
      click_on "Add"
    end

    fill_in "Code", with: "NewCode"
    fill_in "Name", with: "NewName"
    click_on "Create"

    within ".hospital-wards" do
      expect(page).to have_content("NewCode")
      expect(page).to have_content("NewName")
    end
  end
end
