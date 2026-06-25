describe Renalware::TableLoadingComponent, type: :component do
  it "renders skeleton rows and cells for a loading table" do
    render_inline(described_class.new(rows: 2, columns: 3, label: "Loading widget rows"))

    expect(page).to have_css(".system-table-loading[role='status']")
    expect(page).to have_css(".sr-only", text: "Loading widget rows", visible: :all)
    expect(page).to have_css(".system-table-loading__row", count: 2)
    expect(page)
      .to have_css(
        ".system-table-loading__row:first-child .system-table-loading__column",
        count: 3
      )
    expect(page).to have_css(".system-table-loading__cell", count: 6)
  end

  it "can render skeleton rows as a busy overlay around loaded table content" do
    component = described_class.new(rows: 1, columns: 2)
    component.with_main_content { "<table><tr><td>Loaded</td></tr></table>".html_safe }

    render_inline(component)

    expect(page).to have_css(".system-table-loading--overlay.loading-element")
    expect(page).to have_css(".system-table-loading__cell", count: 2)
    expect(page).to have_css("td", text: "Loaded")
  end
end
