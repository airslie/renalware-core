describe "Patient menu", :js do
  it "responds to screen size and the menu toggle" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    page.current_window.resize_to(375, 800)

    visit patient_path(patient)

    expect(page).to have_css("body.collapse-patient-menu")
    expect(find("button.patient-menu-toggle")["aria-expanded"]).to eq("false")

    page.current_window.resize_to(1200, 800)

    expect(page).to have_no_css("body.collapse-patient-menu")
    expect(find("button.patient-menu-toggle")["aria-expanded"]).to eq("true")

    page.current_window.resize_to(375, 800)

    expect(page).to have_css("body.collapse-patient-menu")

    click_button(class: "patient-menu-toggle")

    expect(page).to have_no_css("body.collapse-patient-menu")
    expect(find("button.patient-menu-toggle")["aria-expanded"]).to eq("true")
  end

  it "does not change an always-collapsed menu when resizing" do
    user = login_as_clinical
    patient = create(:patient, by: user)
    page.current_window.resize_to(375, 800)
    visit patient_path(patient)
    page.execute_script(<<~JS)
      document.body.classList.add(
        "collapse-patient-menu",
        "always-collapse-patient-menu"
      )
    JS

    page.current_window.resize_to(1200, 800)

    expect(page).to have_css("body.collapse-patient-menu")
    expect(find("button.patient-menu-toggle")["aria-expanded"]).to eq("false")
  end
end
