# rubocop:disable RSpec/ExampleLength
module Renalware
  module Pathology
    describe CreateObservationsGroupedByDateTable2 do
      let(:options) { {} }
      let(:patient) { create(:pathology_patient) }
      let(:another_patient) { create(:pathology_patient) }
      let(:observation_descriptions) { [] }
      let(:code_group) { create(:pathology_code_group, name: "xx") }

      context "when the patient has had path results on several dates in the past" do
        it "creates a paginated table object and the current page only has <per_page> records" do
          Observation.delete_all
          ObservationRequest.delete_all
          RequestDescription.delete_all
          ObservationDescription.delete_all

          dates = [
            Time.zone.parse("2018-01-01 12:12:12"),
            Time.zone.parse("2017-09-01 12:12:12"),
            Time.zone.parse("2017-07-01 12:12:12"),
            Time.zone.parse("2017-01-01 12:12:12")
          ]

          create(
            :pathology_observation_request,
            :full_blood_count_with_observations,
            patient: patient,
            requested_at: dates[0]
          )

          create(
            :pathology_observation_request,
            :full_blood_count_with_observations,
            patient: patient,
            requested_at: dates[1]
          )

          create(
            :pathology_observation_request,
            :renal_live_urea_with_observations,
            patient: patient,
            requested_at: dates[2]
          )

          # This one will land on page 2 so will not be in out results
          create(
            :pathology_observation_request,
            :renal_live_urea_with_observations,
            patient: patient,
            requested_at: dates[3]
          )

          # Sanity check!
          # There should be a certain number of observations over our chosen dates
          expect(patient.reload.observations.count).to eq(12)
          expect(
            patient
              .reload
              .observations
              .order(observed_at: :desc)
              .select(:observed_at)
              .group(:observed_at)
              .pluck(:observed_at)
              .map(&:round)
          ).to eq(dates)

          descriptions = ObservationDescription.select(:id, :code).all
          descriptions.each do |desc|
            create(
              :pathology_code_group_membership,
              code_group: code_group,
              observation_description: desc
            )
          end

          # expect(descriptions.map(&:code).sort).to match_array(%w(HGB NA PLT POT URE WBC))

          service = described_class.new(
            patient: patient,
            code_group_name: "xx"
          )

          table = service.call

          pending "need to understand why 4 rows returned not 3"

          expect(table.rows.count).to eq(3)
        end
      end

      context "when the patient has >1 of the same observation on the same but with different " \
              "observed_on date times" do
        it "groups observations by date but takes the most recently observed result" do
          date = Time.zone.parse("2019-01-01 12:00:00")

          # Note the OBR requested_at should not bmake a difference so we have set in the far past
          request = create(
            :pathology_observation_request,
            patient: patient,
            requested_at: 100.years.ago,
            filler_order_number: "A"
          )
          hgb = create(:pathology_observation_description, :hgb)
          create(
            :pathology_code_group_membership,
            code_group: code_group,
            observation_description: hgb
          )

          # Create three observations to simulate them arriving at different times (e.g. via HL7)
          # but there observed_on datetime (which is the significant attribute for sorting) is
          # not in order.
          dates = [date, date + 1.minute, date - 1.minute]
          observations = dates.each_with_index.map do |observed_at, value|
            create(
              :pathology_observation,
              request: request,
              description: hgb,
              observed_at: observed_at,
              result: value
            )
          end
          expected_observation = observations[1] # the one with the most recent observed_at

          # There should be a certain number of observations over our chosen dates
          expect(patient.reload.observations.count).to eq(3)

          descriptions = ObservationDescription.select(:id, :code).all
          expect(descriptions.map(&:code).sort).to eq(["HGB"])

          service = described_class.new(
            patient: patient,
            code_group_name: "xx"
          )

          table = service.call

          expect(table.rows.count).to eq(1)
          row = table.rows.first
          expect(row.observed_at).to eq(Time.zone.parse("2019-01-01"))
          expect(row.result_for("HGB")).to eq(expected_observation.result)
        end
      end

      context "when UTC conversion during BST moves a near-midnight date to the previous day" do
        it "reapplies Europe/London timezone to the date so the date is correct" do
          troublesome_datetime = Time.zone.parse("2025-04-10 00:00:00") # stored UTC as 23:00:00
          request = create(
            :pathology_observation_request,
            patient: patient,
            filler_order_number: "A"
          )
          hgb = create(:pathology_observation_description, :hgb)

          create(
            :pathology_code_group_membership,
            code_group: code_group,
            observation_description: hgb
          )

          obx = create(
            :pathology_observation,
            request: request,
            description: hgb,
            observed_at: troublesome_datetime,
            result: 123
          )

          # sanity check - the utc version is how the date is stored (Rails applies timezone)
          expect(obx.reload.observed_at.utc.to_s).to eq "2025-04-09 23:00:00 UTC"
          expect(obx.observed_at.to_s).to eq "2025-04-10 00:00:00 +0100" # BST starts 30-03-2025

          # OK, now we exercise the view, and expect to see the correct BST date
          service = described_class.new(
            patient: patient,
            code_group_name: "xx"
          )

          table = service.call

          expect(table.rows.count).to eq(1)
          row = table.rows.first
          expect(row.observed_at.to_s).to eq("2025-04-10")
          expect(row.result_for("HGB")).to eq("123")
        end
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength
