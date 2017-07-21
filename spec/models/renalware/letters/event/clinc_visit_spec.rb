require "rails_helper"

module Renalware::Letters
  describe Event::ClinicVisit do
    context "for a clinical letter" do
      subject { described_class.new(nil, clinical: true) }

      describe "#part_classes" do
        it "contains the default clinical part classes and clinical" do
          expect(subject.part_classes).to eq(
            {
              problems: Part::Problems,
              prescriptions: Part::Prescriptions,
              recent_pathology_results: Part::RecentPathologyResults,
              clinical_observations: Part::ClinicalObservations,
              allergies: Part::Allergies
            }
          )
        end
      end

      it "has a #to_s of Clinical" do
        expect(subject.to_s).to eq("Clinic Visit")
      end

      it "is clinical" do
        expect(subject.clinical?).to be_truthy
      end
    end
  end
end
