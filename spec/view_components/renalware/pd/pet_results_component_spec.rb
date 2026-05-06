describe Renalware::PD::PETResultsComponent, type: :component do
  describe "#title" do
    it "shows the total count when all results fit in the initial page" do
      component = described_class.new(
        patient: build_stubbed(:pd_patient),
        current_user: build_stubbed(:user)
      )
      allow(component)
        .to receive(:pagination)
        .and_return(instance_double(Pagy::Offset, in: 1, count: 1))

      expect(component.title).to eq("PET Results (1)")
    end

    it "shows the initial page size and total count when more results are available" do
      component = described_class.new(
        patient: build_stubbed(:pd_patient),
        current_user: build_stubbed(:user)
      )
      allow(component)
        .to receive(:pagination)
        .and_return(instance_double(Pagy::Offset, in: 6, count: 20))

      expect(component.title).to eq("PET Results (6 of 20)")
    end
  end

  context "when there are no results" do
    it "renders nothing" do
      user = build_stubbed(:user)
      patient = build_stubbed(:pd_patient)
      component = described_class.new(patient:, current_user: user)
      allow(component).to receive(:results).and_return([])

      render_inline(component).to_html

      expect(page.text).to be_blank
    end
  end

  context "when there are results" do
    it "renders nothing" do
      patient = build_stubbed(:pd_patient)
      user = build_stubbed(:user)
      component = described_class.new(patient:, current_user: user)
      result = build_stubbed(:pd_pet_result, patient:, performed_on: "2020-01-01")
      allow(component).to receive_messages(
        results: [result],
        pagination: Renalware::NullObject.instance
      )

      render_inline(component).to_html

      expect(page).to have_text "01-Jan-2020"
    end
  end
end
