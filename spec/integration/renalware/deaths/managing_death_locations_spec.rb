# frozen_string_literal: true

require "rails_helper"

describe "Death location management", type: :system do
  it "enables me to list locations" do
    login_as_super_admin

    locations = [
      create(:death_location, :hospice),
      create(:death_location, :hospital)
    ]

    visit deaths_locations_path

    expect(page).to have_content("Death Locations")
    locations.each do |location|
      expect(page).to have_content(location.name)
    end
  end

  it "enables me to add a location" do
    login_as_super_admin

    visit deaths_locations_path

    within(".page-heading") do
      click_on "Add"
    end

    fill_in "Name", with: "New Location"
    click_on "Create"

    expect(Renalware::Deaths::Location.count).to eq(1)
    expect(Renalware::Deaths::Location.first.name).to eq("New Location")
  end

  # it "enables me to edit a clinic" do
  #   login_as_super_admin

  #   clinic = create(:clinic, name: "Name1", code: "Code1")

  #   visit clinics_path

  #   within("#clinics_clinic_#{clinic.id}") do
  #     click_on "Edit"
  #   end

  #   fill_in "Name", with: "Name2"
  #   fill_in "Code", with: "Code2"
  #   click_on "Save"

  #   expect(clinic.reload).to have_attributes(
  #     name: "Name2",
  #     code: "Code2"
  #   )
  # end

  # it "enables me to soft delete a clinic" do
  #   login_as_super_admin

  #   clinic = create(:clinic, name: "Name1", code: "Code1")

  #   visit clinics_path

  #   within("#clinics_clinic_#{clinic.id}") do
  #     click_on "Delete"
  #   end

  #   deleted_clinic = Renalware::Clinics::Clinic.with_deleted.find(clinic.id)
  #   expect(deleted_clinic.deleted_at).not_to be_nil
  # end
end
