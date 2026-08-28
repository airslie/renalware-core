describe "Editing the virology profile" do
  let(:patient) { create(:virology_patient) }

  it "builds a new profile for the form if the patient had none" do
    login_as_clinical
    visit patient_virology_dashboard_path(patient)

    within ".page-actions" do
      click_on "Edit Profile"
    end

    expect(page).to have_current_path(edit_patient_virology_profile_path(patient))
    expect(page).to have_css(".rw-form .rw-field-row:not(.rw-field-row--header)", count: 5)
    expect(page).to have_css("form.rw-form.max-w-5xl")
    expect(page).to have_no_css(".rw-form .columns")

    within(".rw-field-row--header") do
      expect(page).to have_css(".rw-control-label", text: "Status")
      expect(page).to have_css(".rw-control-label", text: "Diagnosed")
      expect(page).to have_css(".rw-control-label", text: "Ended")
    end

    within(".hiv") do
      expect(page).to have_css("[class~='sm:grid-cols-3']")
      expect(page).to have_css(
        "fieldset legend[class~='sm:sr-only']", text: "Status", visible: :all
      )
    end

    within(".hepatitis_c") do
      expect(page).to have_css("[class~='sm:grid-cols-3']")
      expect(page).to have_css(
        "fieldset legend[class~='sm:sr-only']", text: "Status", visible: :all
      )
      expect(page).to have_css(
        ".rw-control-label[class~='sm:sr-only']", text: "Diagnosed", visible: :all
      )
      expect(page).to have_css(
        ".rw-control-label[class~='sm:sr-only']", text: "Ended", visible: :all
      )
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

  it "swaps the shared header for inline row captions on narrow viewports", :js do
    login_as_clinical
    visit edit_patient_virology_profile_path(patient)

    header_display = "getComputedStyle(document.querySelector('.rw-field-row--header')).display"
    hiv_status_width =
      "document.querySelector('.hiv fieldset legend').getBoundingClientRect().width"

    page.current_window.resize_to(1200, 900)
    expect(page.evaluate_script(header_display)).to eq("grid")
    expect(page.evaluate_script(hiv_status_width)).to be < 2

    page.current_window.resize_to(375, 900)
    expect(page.evaluate_script(header_display)).to eq("none")
    expect(page.evaluate_script(hiv_status_width)).to be > 10
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
