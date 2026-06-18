describe Renalware::DropdownButtonComponent, type: :component do
  it "renders a stimulus dropdown button with configurable title, icon and classes" do
    render_inline(
      described_class.new(
        title: "Print&hellip;".html_safe,
        icon: :printer,
        button_classes: "btn btn-primary",
        items: [
          { title: "All Drugs", url: "/all-drugs" },
          { title: "HD Drugs", url: "/hd-drugs", target: "_blank" }
        ],
        menu_id: "print-options"
      )
    )

    expect(page).to have_css("div[data-controller='dropdown']")
    expect(page).to have_button("Print…", class: "btn btn-primary")
    expect(page).to have_css("button[aria-controls='print-options'][aria-expanded='false']")
    expect(page).to have_css("button[data-action='dropdown#toggle click@window->dropdown#hide']")
    expect(page).to have_css("button svg", count: 2)
    expect(page).to have_css("#print-options.dropdown-drawer.hidden[data-dropdown-target='menu']")
    expect(page).to have_link("All Drugs", href: "/all-drugs")
    expect(page).to have_link("HD Drugs", href: "/hd-drugs")
    expect(page).to have_css("a[target='_blank']", text: "HD Drugs")
  end

  it "adds the dropdown toggle action to item links" do
    render_inline(
      described_class.new(
        title: "Print",
        items: [
          { title: "All Drugs", url: "/all-drugs" },
          { title: "HD Drugs", url: "/hd-drugs", data: { action: "analytics#track" } }
        ]
      )
    )

    expect(page).to have_css("a[data-action='dropdown#toggle']", text: "All Drugs")
    expect(page).to have_css("a[data-action='dropdown#toggle analytics#track']", text: "HD Drugs")
  end

  it "renders custom block content in the dropdown menu" do
    render_inline(described_class.new(title: "Resolve", menu_id: "resolve-options")) do
      '<a class="block" href="/allocated">Allocated</a><hr>'.html_safe
    end

    expect(page).to have_link("Allocated", href: "/allocated")
    expect(page).to have_css("#resolve-options hr")
  end

  it "renders slot items added conditionally in the component block" do
    render_hidden_item = false

    render_inline(described_class.new(title: "Actions", menu_id: "action-options")) do |dropdown|
      dropdown.with_item(
        title: "Allowed",
        url: "/allowed",
        icon: :check,
        data: { turbo: true, "reveal-id" => "print-modal", "reveal-ajax" => "true" }
      )
      dropdown.with_item(title: "Hidden", url: "/hidden") if render_hidden_item
      dropdown.with_item(title: "Disabled", enabled: false)
      nil
    end

    expect(page).to have_link("Allowed", href: "/allowed")
    expect(page).to have_no_link("Hidden")
    expect(page).to have_css("a[data-turbo='true']", text: "Allowed")
    expect(page).to have_css(
      "a[data-action='dropdown#toggle'][data-reveal-id='print-modal'][data-reveal-ajax='true']",
      text: "Allowed"
    )
    expect(page).to have_css("a svg")
    expect(page).to have_css("span", text: "Disabled")
    expect(page).to have_no_link("Disabled")
  end

  it "can render disabled item text" do
    render_inline(
      described_class.new(
        title: "Actions",
        items: [{ title: "Nothing available", url: nil, enabled: false }]
      )
    )

    expect(page).to have_css("span", text: "Nothing available")
    expect(page).to have_no_link("Nothing available")
  end
end
