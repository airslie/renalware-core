describe Renalware::Medications::AdministerOutpatientPrescriptionDropdownComponent,
         type: :component do
  it "renders the button title" do
    patient = Renalware::Patient.new

    render_inline(described_class.new(patient:))

    expect(page).to have_text("Record Outpatient Drugs")
    expect(page).to have_css("div[data-controller='dropdown']")
    expect(page).to have_button("Record Outpatient Drugs…")
    expect(page).to have_css(
      "button[aria-controls='outpatient-prescription-options'][aria-expanded='false']"
    )
    expect(page).to have_css(
      "#outpatient-prescription-options.dropdown-drawer.hidden[data-dropdown-target='menu']"
    )
  end

  context "when the patient has no drugs to be given as an outpatient" do
    it "indicates no drugs are available" do
      patient = Renalware::Patient.new

      render_inline(described_class.new(patient:))

      expect(page).to have_text("Patient has no drugs to be given as an outpatient")
    end
  end

  context "when the patient has outpatient drugs" do
    it "renders one dropdown link per eligible prescription" do
      patient = create(:patient)
      eligible = create(
        :prescription,
        patient:,
        give_as_outpatient: true,
        drug: create(:drug, name: "Drug 1")
      )
      create(
        :prescription,
        patient:,
        give_as_outpatient: false,
        drug: create(:drug, name: "Drug 2")
      )

      render_inline(described_class.new(patient:))

      expect(page).to have_text("Drug 1")
      expect(page).to have_no_text("Drug 2")
      expect(page).to have_link(
        href: new_medications_prescription_outpatient_administration_path(eligible, format: :html)
      )
      expect(page).to have_css(
        "a[data-action='dropdown#toggle'][data-reveal-id=" \
        "'outpatient-prescription-administration-modal'][data-reveal-ajax='true']",
        text: "Drug 1"
      )
    end
  end
end
