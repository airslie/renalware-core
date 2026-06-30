describe Renalware::Medications::OutpatientPrescriptionLastAdministrationComponent,
         type: :component do
  it "renders the last time the prescription was administered" do
    user = build_stubbed(:user)
    patient = build_stubbed(:patient, by: user)
    prescription = build_stubbed(:prescription, patient:, by: user)
    administration = build_stubbed(
      :outpatient_prescription_administration,
      prescription:,
      patient:,
      administered_by: user,
      recorded_on: Date.parse("01-01-2020"),
      notes: "abc"
    )
    allow(Renalware::Medications::OutpatientPrescriptionAdministrationsQuery)
      .to receive(:call).and_return([administration])

    render_inline(described_class.new(prescription:))

    expect(page).to have_text("Last given on Wed 01-Jan-2020 by #{user}")
    expect(page).to have_text("Notes: abc")
  end

  it "renders the fixed-dose progress when present" do
    user = create(:user)
    prescription = create(
      :prescription,
      give_as_outpatient: true,
      fixed_number_of_doses: 5,
      by: user
    )
    administration = create(
      :outpatient_prescription_administration,
      prescription:,
      administered_by: user,
      recorded_on: Date.parse("01-01-2020")
    )
    allow(Renalware::Medications::OutpatientPrescriptionAdministrationsQuery)
      .to receive(:call).and_return([administration])

    render_inline(described_class.new(prescription:))

    expect(page).to have_text("Last given on Wed 01-Jan-2020 by #{user}")
    expect(page).to have_text("1 of 5 already given")
  end

  it "renders the fixed-dose progress when there is no last administration" do
    prescription = create(
      :prescription,
      give_as_outpatient: true,
      fixed_number_of_doses: 5
    )
    allow(Renalware::Medications::OutpatientPrescriptionAdministrationsQuery)
      .to receive(:call).and_return([])

    render_inline(described_class.new(prescription:))

    expect(page).to have_text("0 of 5 already given")
  end

  context "when prescription is nil" do
    it "renders nothing" do
      component = described_class.new(prescription: nil)

      render_inline(component)

      expect(component.render?).to be(false)

      expect(page.text).to be_blank
    end
  end
end
