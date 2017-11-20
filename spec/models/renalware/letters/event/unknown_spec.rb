require "rails_helper"

module Renalware::Letters
  describe Event::Unknown do
    context "for a clinical letter" do
      subject { described_class.new(nil, clinical: true) }

      describe "#part_classes" do
        it "contains the default clinical part classes" do
          expect(subject.part_classes).to eq(
            {
              problems: Part::Problems,
              prescriptions: Part::Prescriptions,
              recent_pathology_results: Part::RecentPathologyResults,
              allergies: Part::Allergies
            }
          )
        end
      end

      it "has a #to_s of Clinical" do
        expect(subject.to_s).to eq("Clinical")
      end

      it "is clinical" do
        expect(subject).to be_clinical
      end
    end

    context "for a non-clinical letter" do
      subject { described_class.new(nil) }

      describe "#part_classes" do
        it "is an empty hash" do
          expect(subject.part_classes).to eq({})
        end
      end

      it "has a #to_s of Simple" do
        expect(subject.to_s).to eq("Simple")
      end

      it "is not clinical" do
        expect(subject).not_to be_clinical
      end
    end
  end
end
