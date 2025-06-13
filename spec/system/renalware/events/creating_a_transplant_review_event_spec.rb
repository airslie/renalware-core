describe "Creating an medication review event", :js do
  it "captures extra data" do
    user = login_as_clinical
    patient = create(:patient, by: user)

    create(:biopsy_event_type)
    event_type = create(:transplant_review_event_type)

    visit new_patient_event_path(patient)

    slim_select "Transplant Review", from: "Event type"

    click_on t("btn.create")

    expect(page).to have_current_path(patient_events_path(patient))
    events = Renalware::Events::Event.for_patient(patient)
    expect(events.length).to eq(1)
    expect(events.first.event_type_id).to eq(event_type.id)
  end
end
