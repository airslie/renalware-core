RSpec.describe "Filtering outpatient prescription administrations", :js do
  let(:patient) { create(:patient) }

  it "filters the index by administered drug name" do
    prescription_a = create(
      :prescription,
      patient:,
      give_as_outpatient: true,
      drug: create(:drug, name: "AlphaDrug")
    )
    prescription_b = create(
      :prescription,
      patient:,
      give_as_outpatient: true,
      drug: create(:drug, name: "BetaDrug")
    )
    prescription_c = create(
      :prescription,
      patient:,
      give_as_outpatient: true,
      drug: create(:drug, name: "GammaDrug")
    )

    create(
      :outpatient_prescription_administration,
      patient:,
      prescription: prescription_a,
      administered: true
    )
    create(
      :outpatient_prescription_administration,
      patient:,
      prescription: prescription_b,
      administered: true
    )
    create(
      :outpatient_prescription_administration,
      patient:,
      prescription: prescription_c,
      administered: false
    )

    login_as_clinical

    visit patient_medications_outpatient_prescription_administrations_path(patient)

    expect(page).to have_select("Drug", options: ["All drugs", "AlphaDrug", "BetaDrug"])
    expect(page).to have_no_select("Drug", with_options: ["GammaDrug"])

    select "AlphaDrug", from: "Drug"
    click_on "Filter"

    within "#outpatient-prescription-administrations" do
      expect(page).to have_text("AlphaDrug")
      expect(page).to have_no_text("BetaDrug")
      expect(page).to have_no_text("GammaDrug")
    end
  end
end
