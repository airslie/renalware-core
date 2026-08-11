describe "renalware/events/subtypes/_form.html.slim" do
  it "marks layout field rows as draggable sortable items" do
    event_type = create(:research_study_event_type)
    subtype = build(:event_subtype, event_type:)
    subtype.fields = [
      Renalware::Events::SubtypesController::FieldInfo.new(name: "text1", label: "Text 1"),
      Renalware::Events::SubtypesController::FieldInfo.new(name: "text2", label: "Text 2")
    ]

    render partial: "renalware/events/subtypes/form", locals: { layout: subtype }

    fragment = Nokogiri::HTML.fragment(rendered)
    rows = fragment.css("tbody[data-controller='sortable'] tr.sortable")

    expect(rows.size).to eq(2)
    expect(rows.css("td.handle").size).to eq(2)
    expect(rows.css("input").pluck("name")).to eq(
      [
        "layout[fields][text1][label]",
        "layout[fields][text2][label]"
      ]
    )
  end
end
