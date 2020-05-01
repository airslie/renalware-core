# frozen_string_literal: true

require "rails_helper"

describe Renalware::PD::PETResultsComponent, type: :component do
  context "when there are no results" do
    it "renders nothing" do
      component = described_class.new(patient: build_stubbed(:pd_patient))
      allow(component).to receive(:results).and_return([])

      html = render_inline(component).to_html
      expect(html).to be_blank
    end
  end

  context "when there are results" do
    it "renders nothing" do
      patient = build_stubbed(:pd_patient)
      component = described_class.new(patient: patient)
      result = build_stubbed(:pd_pet_result, patient: patient, performed_on: "2020-01-01")
      allow(component).to receive(:results).and_return([result])
      allow(component).to receive(:pagination).and_return(Renalware::NullObject.instance)

      html = render_inline(component).to_html

      expect(html).to match "01-Jan-2020"
    end
  end
end
