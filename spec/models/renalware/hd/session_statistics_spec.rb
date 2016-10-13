require "rails_helper"

module Renalware
  module HD
    describe SessionStatistics, focus: true do

       #def stub_sessions(observations_before: {}, observations_before: {})

        # we want to create an array of sessions.
        # assumptions
        # - the 3 ranges of pre and post systolic and diastolic must have the same length
        # - either can be empty so there is no blood pressure reading
        # pseudo code
        #
        # get max readings
        # pre_systolic_bps = *observations_before.try(:systolic)
        # pre_diastolic_bps = *observations_before.try(:diastolic)
        # post_systolic_bps = *observations_after.try(:systolic)
        # post_diastolic_bps = *observations_after.try(:diastolic)
        # max = [pre_systolic_bps, post_systolic_bps].map(&:count).max
        # (0..max),each do |index|
        #   pre_bp = BloodPressure.new(systolic: pre_systolic_bps[index], diastolic: diastolic[count - 1])
        # @sessions << double(
        #    observations_before: OpenStruct.new(blood_pressure: BloodPressure.new(systolic: systolic, diastolic: diastolic[count - 1])),
        #    observations_after: OpenStruct.new(blood_pressure: BloodPressure.new(systolic: systolic, diastolic: diastolic[count - 1]))
        #  )
        # end


        # systolic = *systolic_range
        # diastolic = *diastolic_range
        # fail unless systolic.count == diastolic.count

        # @sessions = []
        # systolic.each_with_index do |systolic, count|
        #   bp = BloodPressure.new(systolic: systolic, diastolic: diastolic[count - 1])
        #   @sessions << double(
        #     observations_before: OpenStruct.new(blood_pressure: bp),
        #     observations_after: OpenStruct.new(blood_pressure: bp)
        #   )
        # end
      #end

      def stub_sessions(observations:, systolic_range:, diastolic_range:)
        systolic = *systolic_range
        diastolic = *diastolic_range
        # Coerce to Array in case there was a single value
        systolic = Array(systolic)
        diastolic = Array(diastolic)
        fail unless systolic.count == diastolic.count

        @sessions = []
        systolic.each_with_index do |systolic, count|
          bp = BloodPressure.new(systolic: systolic, diastolic: diastolic[count - 1])
          sesh = Session::Closed.new
          sesh.document[observations].blood_pressure = bp
          @sessions << sesh
        end
      end

      subject(:audit) { SessionStatistics.new(@sessions) }
      it { is_expected.to be_a(Renalware::HD::SessionStatistics) }

      describe "Mean blood pressure" do

        it "calculates pre mean blood pressures" do
          stub_sessions(observations: :observations_before,
                        systolic_range: (101..112),
                        diastolic_range: (81..92))

          expect(audit.pre_mean_systolic_blood_pressure).to eq(106.5)
          expect(audit.pre_mean_diastolic_blood_pressure).to eq(86.5)
        end

        it "calculates post mean blood pressures" do
          stub_sessions(observations: :observations_after,
                        systolic_range: (101..112),
                        diastolic_range: (81..92))

          expect(audit.post_mean_systolic_blood_pressure).to eq(106.5)
          expect(audit.post_mean_diastolic_blood_pressure).to eq(86.5)
        end

        it "returns the mean value is the session value when there is only one session" do
          stub_sessions(observations: :observations_after,
                        systolic_range: 101,
                        diastolic_range: 81)

          expect(audit.post_mean_systolic_blood_pressure).to eq(101)
          expect(audit.post_mean_diastolic_blood_pressure).to eq(81)
        end

        it "the mean value is 0 if there are no sessions" do
          stub_sessions(observations: :observations_after,
                        systolic_range: [],
                        diastolic_range: [])

          expect(audit.post_mean_systolic_blood_pressure).to eq(0)
          expect(audit.post_mean_diastolic_blood_pressure).to eq(0)
        end

        it "returns is 0 for sessions with nil blood pressure measurement" do
          stub_sessions(observations: :observations_after,
                        systolic_range: [nil],
                        diastolic_range: [nil])
          expect(audit.post_mean_systolic_blood_pressure).to eq(0)
          expect(audit.post_mean_diastolic_blood_pressure).to eq(0)
        end
      end

      describe "Highest systolic blood pressure" do
        it "returns a BloodPressure object" #do
        #   pending
        #   stub_sessions(observations: :observations_after,
        #                 systolic_range: (100..105),
        #                 diastolic_range: (80..85))

        #   bp = audit.highest_systolic_blood_pressure
        #   expect(bp).to be_a(BloodPressure)
        #   expect(bp.systolic).to eq(105)
        #   expect(bp.diastolic).to eq(85)
        # end
      end

      describe "#mean_fluid_removal" do
        it "calculates the mean value of fluid removed" do
          @sessions = [1.2, 1.3, 1.4, 1.5].map do |fluid_removed|
            Session::Closed.new.tap do |session|
              session.document.dialysis.fluid_removed = fluid_removed
            end
          end

          expect(audit.mean_fluid_removal).to eq(1.35)
        end

        it "if there is a nil value it is excluded from the mean calculation" do
          @sessions = [1.2, 1.3, nil, 1.4].map do |fluid_removed|
            Session::Closed.new.tap do |session|
              session.document.dialysis.fluid_removed = fluid_removed
            end
          end

          expect(audit.mean_fluid_removal).to eq(1.3)
        end
      end
    end
  end
end
