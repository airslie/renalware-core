describe "Configuring primary care physicians", :js do
  it "toggles the alternative address form" do
    login_as_super_admin

    visit new_patients_primary_care_physician_path

    expect(page).to have_css("#address-form", visible: :hidden)

    click_on "Alternative address"

    expect(page).to have_css("#address-form", visible: :visible)

    click_on "Alternative address"

    expect(page).to have_css("#address-form", visible: :hidden)
  end
end
