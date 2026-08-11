describe "Primary navigation", :js do
  it "switches back to desktop navigation when resizing with the mobile menu open" do
    login_as_clinical
    page.current_window.resize_to(375, 800)

    visit dashboard_path

    find(".rw-primary-nav__toggle").click
    expect(page).to have_css(".rw-primary-nav.rw-primary-nav--open")

    page.current_window.resize_to(1200, 800)

    expect(page).to have_no_css(".rw-primary-nav.rw-primary-nav--open")
    expect(find(".rw-primary-nav__toggle", visible: :all)["aria-expanded"]).to eq("false")
    expect(
      page.evaluate_script(
        "getComputedStyle(document.querySelector('.rw-primary-nav__menu')).display"
      )
    ).to eq("flex")
  end
end
