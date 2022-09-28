# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe Event::ClinicVisit do
    context "with a clinical letter" do
      subject(:clinic_visit) { described_class.new(nil, clinical: true) }

      describe "#part_classes" do
        it "contains the default clinical part classes and clinical" do
          expect(clinic_visit.part_classes).to eq \
            [
              Part::Problems,
              Part::Prescriptions,
              Part::RecentPathologyResults,
              Part::Allergies,
              Part::ClinicalObservations
            ]
        end
      end

      describe ".to_s" do
        subject { clinic_visit.to_s }

        it { is_expected.to eq("Clinic Visit") }
      end

      it { is_expected.to be_clinical }
    end
  end
end
