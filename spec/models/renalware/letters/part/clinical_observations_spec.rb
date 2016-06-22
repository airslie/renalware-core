require "rails_helper"

module Renalware::Letters
  describe Part::ClinicalObservations do
    let(:clinic_visit_event) {
      double(:clinic_visit,
        height: 180.0, weight: 90.0, bp: "110/70",
        bmi: 40.0, urine_blood: "+", urine_protein: "+"
      )
    }
    let(:patient) { double(:patient) }
    subject(:clinical_observations_part) { Part::ClinicalObservations.new(patient, clinic_visit_event) }

    it "delegates the height to the event" do
      expect(clinical_observations_part.height).to eq(180.0)
    end

    it "delegates the weight to the event" do
      expect(clinical_observations_part.weight).to eq(90.0)
    end

    it "delegates the bp to the event" do
      expect(clinical_observations_part.bp).to eq("110/70")
    end

    it "delegates the bmi to the event" do
      expect(clinical_observations_part.bmi).to eq(40.0)
    end

    it "delegates the urine_blood to the event" do
      expect(clinical_observations_part.urine_blood).to eq("+")
    end

    it "delegates the urine_protein to the event" do
      expect(clinical_observations_part.urine_protein).to eq("+")
    end
  end
end
