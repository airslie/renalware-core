require "rails_helper"

module Renalware
  module Pathology
    describe ObservationsDiff do
      let(:patient) { create(:patient) }
      let(:between_dates) { [Time.zone.now, Time.zone.now - 1.month] }
      let(:path_descriptions) { Pathology::ObservationDescription.for(%w(HGB PLT)) }

      def create_diff(between_dates:, for_descriptions:)
        described_class.new(
          patient: patient,
          between_dates: between_dates,
          descriptions: for_descriptions
        )
      end

      it "raises an error if 2 dates are not supplied" do
        expect do
          create_diff(between_dates: [Time.zone.now], for_descriptions: [])
        end.to raise_error(ArgumentError)
      end

      describe "#diff" do
        it "returns a hash" do
          diff = create_diff(between_dates: between_dates, for_descriptions: path_descriptions)
          expect(diff.to_h).to be_kind_of(Hash)
        end

        it "returns a diff between two snapshots of patient pathology" do
          create_initial_pathology_for(patient)
          diff = create_diff(between_dates: between_dates, for_descriptions: path_descriptions)
          expect(diff.to_h).to be_kind_of(Hash)
        end
      end

      describe "#to_html" do
        it "if 2 dates are not supplied" do
          diff = described_class.new(
            patient: patient,
            between_dates: between_dates,
            descriptions: path_descriptions
          )
          html = diff.to_html
          expect(html).not_to be_blank
          expect(html).to match(/<table/)
        end
      end

      def create_initial_pathology_for(patient)
        observation_request = create(
          :pathology_observation_request,
          patient: Pathology.cast_patient(patient)
        )
        hgb_description = create(
          :pathology_observation_description,
          code: "HGB",
          name: "HGB"
        )
        create(
          :pathology_observation,
          request: observation_request,
          description: hgb_description,
          observed_at: "05-Apr-2016",
          result: 1.1
        )
      end

      def create_extra_pathology_for(patient)
        # There has been a new OBR
        observation_request = create(
          :pathology_observation_request,
          patient: Pathology.cast_patient(patient)
        )
        plt_description = create(
          :pathology_observation_description,
          code: "PLT",
          name: "PLT"
        )
        create(
          :pathology_observation,
          request: observation_request,
          description: plt_description,
          observed_at: "06-Apr-2016",
          result: 2.2
        )
      end
    end
  end
end
