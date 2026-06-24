describe Renalware::TableLoadingComponent, type: :component do
  it "renders skeleton rows and cells for a loading table" do
    render_inline(described_class.new(rows: 2, columns: 3, label: "Loading widget rows"))

    expect(page).to have_css(".system-table-loading[role='status']")
    expect(page).to have_css(".sr-only", text: "Loading widget rows", visible: :all)
    expect(page).to have_css("tbody tr", count: 2)
    expect(page).to have_css("tbody tr:first-child td", count: 3)
    expect(page).to have_css(".system-table-loading__cell", count: 6)
  end
end
