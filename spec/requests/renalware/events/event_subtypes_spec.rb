describe "Configuring event subtypes" do
  it "creates a subtype with its dynamic field definitions" do
    event_type = create(:research_study_event_type)

    expect {
      post events_type_subtypes_path(event_type), params: {
        layout: {
          name: "Blood results",
          description: "Selected study measurements",
          fields: {
            number1: { label: "Creatinine" },
            date1: { label: "Measured on" }
          },
          event_type_id: create(:simple_event_type).id
        }
      }
    }.to change(event_type.subtypes, :count).by(1)

    expect(event_type.subtypes.order(:id).last).to have_attributes(
      name: "Blood results",
      description: "Selected study measurements",
      definition: [
        { "number1" => { "label" => "Creatinine" } },
        { "date1" => { "label" => "Measured on" } }
      ]
    )
    expect(response).to redirect_to(events_type_subtypes_path(event_type))
  end
end
