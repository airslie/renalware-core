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


      describe SessionStatistics::MeanValueStrategy do
        subject(:strategy) { SessionStatistics::MeanValueStrategy }

        it "calculates the mean from a number of values" do
          sessions = [ { x: 1.1 }, { x: 1.2 }, { x: 1.3 } ]
          selector = ->(session) { session[:x] }
          result = strategy.call(sessions: sessions, selector: selector)
          expect(result).to eq(1.2)
        end

        it "returns the only value if there is just one" do
          sessions = [ { x: 1.99999 }]
          selector = ->(session) { session[:x] }
          result = strategy.call(sessions: sessions, selector: selector)
          expect(result).to eq(2.0) # 1.9999 rounded up to 2.0
        end

        it "excludes nil values from the mean calculation" do
          sessions = [ { x: 1.1 }, { x: 1.2 }, { x: nil }, { x: 1.3 } ]
          selector = ->(session) { session[:x] }
          result = strategy.call(sessions: sessions, selector: selector)
          expect(result).to eq(1.2)
        end

        it "returns 0 if there are sessions" do
          selector = ->(session) { session[:x] }
          result = strategy.call(sessions: [], selector: selector)
          expect(result).to eq(0)
        end

        it "returns 0 if there are only nil values" do
          sessions = [{ x: nil }, { x: nil }]
          selector = ->(session) { session[:x] }
          result = strategy.call(sessions: sessions, selector: selector)
          expect(result).to eq(0)
        end

        it "skips nil elements if you use try! in the selector" do
          sessions = [ OpenStruct.new(document: nil),
                       OpenStruct.new(document: OpenStruct.new(x: OpenStruct.new(y: 99)))]
          selector = ->(session) { session.document.try!(:x).try!(:y) }
          result = strategy.call(sessions: sessions, selector: selector)
          expect(result).to eq(99)
        end
      end

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
      end

      describe "highest_systolic_blood_pressure" do
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

      describe "#mean_weight_loss" do
        it "calculates the mean weight loss across a number of sessions " \
           "from the first pre obs to the last post obs" do
          pre_obs_weights = [100, 100, 100]
          post_obs_weights = [97, 98, 99]

          @sessions = (0..2).map do |idx|
            Session::Closed.new.tap do |session|
              session.document.observations_before.weight = pre_obs_weights[idx]
              session.document.observations_after.weight = post_obs_weights[idx]
            end
          end

          # effective weight loss = [3, 2, 1] so mean = 1.99999 rounded to 2 places rounds up to 2
          expect(audit.mean_weight_loss).to eq(2)
        end
      end

      describe "#mean_machine_ktv" do
        it "calculates the mean machine ktv over a series of sessions" do
          ktvs = [0.5, 1.5, 2.2]
          mean = 1.4
          @sessions = (0..2).map do |idx|
            Session::Closed.new.tap do |session|
              session.document.dialysis.machine_ktv = ktvs[idx]
            end
          end

          expect(audit.mean_machine_ktv).to eq(mean)
        end
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
      end

      describe "#mean_blood_flow aka pump speed" do
        it "calculates the mean value of dialysis flow rate" do
          @sessions = [200, 250, 300].map do |blood_flow| # a rate
            Session::Closed.new.tap do |session|
              session.document.dialysis.blood_flow = blood_flow
            end
          end

          expect(audit.mean_blood_flow).to eq(250)
        end
      end
    end
  end
end
