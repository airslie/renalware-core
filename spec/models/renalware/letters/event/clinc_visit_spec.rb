# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe Event::ClinicVisit do
    context "with a clinical letter" do
      subject(:clinic_visit) {
        described_class.new(nil, clinical: true)
      }
      let(:clinic) { build_stubbed(:clinic, name: "X", code: "Y") }

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

      describe ".description" do
        it do
          clinic = build_stubbed(:clinic, name: "X", code: "Y")
          visit = instance_double(Renalware::Clinics::ClinicVisit, date: "2022-02-02",
                                                                   clinic: clinic)
          event = described_class.new(visit, clinical: true)
          expect(event.description).to eq("Clinic X Y Wed 02 Feb 2022")
        end
      end

      it { is_expected.to be_clinical }
    end
  end
end
