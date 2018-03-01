# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters
  describe Part::RecentPathologyResults do
    subject(:part) { described_class.new(patient, letter, event) }

    let(:user) { create(:user) }
    let(:patient) { create(:patient, by: user) }
    let(:event) { nil }
    let(:letter) { Letter.new }

    it { is_expected.to respond_to(:results) }

    describe "#results" do
      subject(:results) { part.results }

      context "when there is pathology_snapshot is nil" do
        let(:letter) { instance_double(Letter, pathology_snapshot: nil) }

        it { is_expected.to be_nil }
      end

      context "when there is pathology_snapshot is an empty hash" do
        let(:letter) { instance_double(Letter, pathology_snapshot: {}) }

        it { is_expected.to be_nil }
      end

      # The setup here is a little involved. We want to replicate a patient
      # with a full set of OBX results. These will have been added to the jsonb hash in
      # pathology_current_observation_sets by a pg triggeras new HL7 results come in, and then
      # when the letter is create, that hash is copied in the jsonb letter.pathology_snapshot,
      # so at that point pathology_current_observation_sets.values == letter.pathology_snapshot.
      # The order in the jsonb is unlikely to match the required order for display in the letter.
      context "when we have a pathology snapshot stored on the letter" do
        let(:letter) { instance_double(Letter, pathology_snapshot: pathology_snapshot) }
        # These are dates we will assign to various OBX results. Note that certain OBX results will
        # arrive together (the were part of the same request, e.g. HG PLT and WBC always
        # come back together if requested in the OBR Full Blood Count (FBC).
        # So in assigning the dates we need to realistic about that, otherwise the output string
        # could get mixed up.
        let(:obr_1_date) { "2016-12-12 00:01:01" }
        let(:obr_2_date) { "2017-12-12 00:12:01" }
        let(:obr_3_date) { "2017-11-11 00:01:01" }
        let(:obr_4_date) { "2017-11-11 00:23:59" }
        let(:obr_5_date) { "2017-10-11 00:23:59" }

        # Randomise the order of entries in the pathology_snapshot in order to
        # mimic how it might be stored. See comment above.
        # This is not the complete set of letter codes in
        # Letters::RelevantObservationDescription.codes, but enough to determine we are
        # outputting the result correctly
        let(:pathology_snapshot) do
          {
            NA: { result: 134, observed_at: obr_3_date },
            PLT: { result: 329, observed_at: obr_1_date },
            WBC: { result: 15.32, observed_at: obr_1_date },
            URE: { result: 24.8, observed_at: obr_2_date },
            ALB: { result: 41, observed_at: obr_5_date },
            EGFR: { result: 6, observed_at: obr_3_date },
            HGB: { result: 122, observed_at: obr_1_date },
            POT: { result: 6.0, observed_at: obr_3_date },
            CRE: { result: 782, observed_at: obr_3_date },
            BIC: { result: 18, observed_at: obr_4_date },
            CCA: { result: 2.29, observed_at: obr_5_date },
            PHOS: { result: 2.52, observed_at: obr_5_date }
          }
        end

        it "returns a string of observations grouped by OBR date "\
           "and ordered correctly" do
          create_all_letter_observation_descriptions
          expected_results =
            "12-Dec-2016: HGB 122, PLT 329, WBC 15.32; "\
            "12-Dec-2017: URE 24.8; "\
            "11-Nov-2017: CRE 782, EGFR 6, POT 6.0, NA 134; "\
            "11-Nov-2017: BIC 18; "\
            "11-Oct-2017: CCA 2.29, PHOS 2.52, ALB 41;"

          expect(results).to eq(expected_results)
        end
      end

      context "when we only have say Full Blood Count results (HGB PLT WBC)" do
        let(:date) { "2016-12-12 00:01:01" }
        let(:pathology_snapshot) do
          {
            PLT: { result: 329, observed_at: date },
            WBC: { result: 15.32, observed_at: date },
            HGB: { result: 122, observed_at: date }
          }
        end
        let(:letter) { instance_double(Letter, pathology_snapshot: pathology_snapshot) }

        it "displays those results and nothing for the others" do
          create_all_letter_observation_descriptions

          expect(results).to eq("12-Dec-2016: HGB 122, PLT 329, WBC 15.32;")
        end
      end

      def create_all_letter_observation_descriptions
        RelevantObservationDescription.codes.each do |code|
          create(:pathology_observation_description, code: code, name: code)
        end
      end
    end
  end
end
