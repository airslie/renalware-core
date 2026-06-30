describe "renalware/medications/prescriptions/_current_outpatient" do
  it "renders nothing when there are no outpatient prescriptions by default" do
    render partial: "renalware/medications/prescriptions/current_outpatient",
           locals: { prescriptions: [], recently_changed: [] }

    expect(rendered).to be_blank
  end

  it "renders an empty state when requested" do
    render partial: "renalware/medications/prescriptions/current_outpatient",
           locals: { prescriptions: [], recently_changed: [], render_if_blank: true }

    expect(rendered).to include("Drugs to give as Outpatient")
    expect(rendered).to include("No prescriptions")
  end
end
