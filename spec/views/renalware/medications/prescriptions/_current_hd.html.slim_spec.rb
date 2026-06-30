describe "renalware/medications/prescriptions/_current_hd" do
  it "renders nothing when there are no HD prescriptions by default" do
    render partial: "renalware/medications/prescriptions/current_hd",
           locals: { prescriptions: [], recently_changed: [] }

    expect(rendered).to be_blank
  end

  it "renders an empty state when requested" do
    render partial: "renalware/medications/prescriptions/current_hd",
           locals: { prescriptions: [], recently_changed: [], render_if_blank: true }

    expect(rendered).to include("Drugs to give on Haemodialysis")
    expect(rendered).to include("No prescriptions")
  end
end
