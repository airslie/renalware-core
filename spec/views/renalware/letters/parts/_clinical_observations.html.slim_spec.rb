# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe "renalware/letters/parts/_clinical_observations", type: :view do
    helper(Renalware::LettersHelper)
    helper(Renalware::AttributeNameHelper)

    let(:partial) { "renalware/letters/parts/clinical_observations" }
    let(:part) { Letters::Part::ClinicalObservations.new(nil, nil, clinic_visit) }
    let(:clinic_visit) {
      Clinics::ClinicVisit.new(
        height: 1.8,
        weight: 90.0,
        bp: "110/70",
        urine_blood: :low,
        urine_protein: :trace
      )
    }

    it "renders the visit observations" do
      render partial: partial, locals: { clinical_observations: part }

      expect(rendered).to include("BMI")
      expect(rendered).to include("27.8")
      expect(rendered).to include("Height")
      expect(rendered).to include("1.8 m")
      expect(rendered).to include("Weight")
      expect(rendered).to include("90.0 kg")
      expect(rendered).to include("BP")
      expect(rendered).to include("110/70")
      expect(rendered).to include("Urine Blood")
      expect(rendered).to include("+")
      expect(rendered).to include("Urine Protein")
      expect(rendered).to include("Trace")
    end

    context "when some observations are missing" do
      let(:clinic_visit) {
        Clinics::ClinicVisit.new(
          height: 1.81,
          urine_protein: :trace
        )
      }

      it "does not render them at all" do
        render partial: partial, locals: { clinical_observations: part }

        expect(rendered).to include("Height")
        expect(rendered).to include("1.81 m")
        expect(rendered).not_to include("Weight")
        expect(rendered).not_to include("BMI") # can't calculate with weight so will be omitted
        expect(rendered).not_to include("BP")
        expect(rendered).not_to include("110/70")
        expect(rendered).not_to include("Urine blood")
        expect(rendered).to include("Urine Protein")
        expect(rendered).to include("Trace")
      end
    end
  end
end
