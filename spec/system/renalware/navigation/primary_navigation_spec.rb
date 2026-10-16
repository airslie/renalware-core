describe "Primary navigation", :js do
  it "scrolls the mobile menu and expanded submenus within the viewport" do
    login_as_clinical
    page.current_window.resize_to(375, 400)

    visit dashboard_path

    find(".rw-primary-nav__toggle").click
    expect_navigation_to_scroll

    find(".rw-primary-nav").evaluate_script("this.scrollTop = 0")
    find("[aria-controls='primary-navigation-user']").click
    expect(page).to have_css("#primary-navigation-user")
    expect_navigation_to_scroll

    page.current_window.resize_to(390, 500)
    expect_navigation_to_scroll
  end

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

  def expect_navigation_to_scroll
    navigation = find(".rw-primary-nav")

    expect(navigation.evaluate_script("getComputedStyle(this).overflowY")).to eq("auto")
    expect(navigation.evaluate_script("this.getBoundingClientRect().bottom"))
      .to be <= page.evaluate_script("window.innerHeight")

    navigation.evaluate_script("this.scrollTop = this.scrollHeight")
    expect(navigation.evaluate_script("this.scrollTop")).to be > 0
    expect(navigation.evaluate_script("this.scrollTop + this.clientHeight"))
      .to be_within(1).of(navigation.evaluate_script("this.scrollHeight"))
  end
end
