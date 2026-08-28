describe "Viewing the admin dashboard" do
  it "lays its components out in a responsive two-column grid" do
    login_as_super_admin

    visit admin_dashboard_path

    expect(page).to have_css(
      ".grid.grid-cols-1.items-start.gap-6[class~='lg:grid-cols-2'] > .min-w-0",
      count: 2
    )
  end
end
