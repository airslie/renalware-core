describe "Editing the virology profile" do
  let(:patient) { create(:virology_patient) }

  it "builds a new profile for the form if the patient had none" do
    login_as_clinical
    visit patient_virology_dashboard_path(patient)

    within ".page-actions" do
      click_on "Edit Profile"
    end

    expect(page).to have_current_path(edit_patient_virology_profile_path(patient))
    expect(page).to have_css(".rw-form .rw-field-row", count: 5)
    expect(page).to have_css("form.rw-form.max-w-7xl")
    expect(page).to have_no_css(".rw-form .columns")

    within(".hiv") do
      expect(page).to have_css("[class~='sm:grid-cols-3']")
    end

    within(".hepatitis_c") do
      expect(page).to have_css("fieldset legend", text: "Status")
      expect(page).to have_css("[class~='sm:grid-cols-3']")
    end

    within(".hiv") do
      choose("Yes")
      select("2012", from: "Diagnosed")
    end

    within(".hepatitis_b") do
      choose("No")
      select("2011", from: "Diagnosed")
    end

    within(".hepatitis_b_core_antibody") do
      choose("Yes")
      select("2010", from: "Diagnosed")
    end

    within(".hepatitis_c") do
      choose("Unknown")
      select("2014", from: "Diagnosed")
      fill_in "Ended", with: "02-Jan-2015"
    end

    within(".htlv") do
      choose("Yes")
      select("2018", from: "Diagnosed")
    end

    within ".patient-content" do
      click_on t("btn.create")
    end

    expect(page).to have_current_path(patient_virology_dashboard_path(patient))

    document = patient.reload.profile.document
    expect(document.hiv.status.to_s).to eq("yes")
    expect(document.hiv.confirmed_on_year).to eq(2012)
    expect(document.hepatitis_b.status.to_s).to eq("no")
    expect(document.hepatitis_b.confirmed_on_year).to eq(2011)
    expect(document.hepatitis_b_core_antibody.status.to_s).to eq("yes")
    expect(document.hepatitis_b_core_antibody.confirmed_on_year).to eq(2010)
    expect(document.hepatitis_c.status.to_s).to eq("unknown")
    expect(document.hepatitis_c.confirmed_on_year).to eq(2014)
    expect(document.hepatitis_c.ended_on).to eq(Date.new(2015, 1, 2))
    expect(document.htlv.status.to_s).to eq("yes")
    expect(document.htlv.confirmed_on_year).to eq(2018)
  end

  it "displays an end-date validation error beside the hepatitis C field" do
    user = login_as_clinical
    profile = patient.create_profile
    profile.document.hepatitis_c.status = :unknown
    profile.document.hepatitis_c.confirmed_on_year = 2014
    profile.save_by!(user)

    visit edit_patient_virology_profile_path(patient)

    within(".hepatitis_c") do
      fill_in "Ended", with: "01-Jan-2014"
    end

    click_on t("btn.update")

    expect(page).to have_current_path(patient_virology_profile_path(patient, profile))
    within(".hepatitis_c") do
      expect(page).to have_css(
        ".rw-error",
        text: "must be after the beginning of the diagnosis year"
      )
    end
  end
end
