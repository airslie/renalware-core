require "rails_helper"

feature "Managing HD Stations for a Hospital Unit", type: :feature do
  before do
    create(:hd_station_location, name: "Side room")
  end

  def create_station(name, unit, by)
    create(:hd_station, name: name, hospital_unit_id: unit.id, by: by)
  end

  scenario "Listing existing stations" do
    user = login_as_read_write
    unit = create(:hospital_unit, unit_code: "UnitCode")
    create_station("Station-1", unit, user)
    create_station("Station-2", unit, user)

    visit hd_unit_stations_path(unit)

    expect(page).to have_content("UnitCode")
    expect(page).to have_content("Station-1")
    expect(page).to have_content("Station-2")
  end

  scenario "Adding a station" do
    login_as_admin
    unit = create(:hospital_unit, unit_code: "UnitCode")

    visit hd_unit_stations_path(unit)
    within(".page-actions") do
      click_on I18n.t("new_record.link_title")
    end

    fill_in "Name", with: "Station-X"
    select "Side room", from: "Location"
    click_on "Save"

    expect(page).to have_current_path(hd_unit_stations_path(unit))
    expect(page).to have_content("Station-X")
    expect(page).to have_content("Side room")
  end

  scenario "Editing a station" do
    user = login_as_admin
    unit = create(:hospital_unit, unit_code: "UnitCode")
    station = create_station("Station-1", unit, user)

    visit hd_unit_stations_path(unit)
    within("#hd-station-#{station.id}") do
      click_on "Edit"
    end

    fill_in "Name", with: "Station-XX"
    click_on "Save"

    expect(page).to have_current_path(hd_unit_stations_path(unit))
    expect(page).to have_content("Station-XX")
  end
end
