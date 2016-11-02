require "rails_helper"

module Renalware
  module HD
    describe SessionStatistics do

      def stub_sessions(observations:, systolic_range:, diastolic_range:)
        systolic = *systolic_range
        diastolic = *diastolic_range
        # Coerce to Array in case there was a single value
        systolic = Array(systolic)
        diastolic = Array(diastolic)
        fail unless systolic.count == diastolic.count

        @sessions = []
        systolic.each_with_index do |systolic_value, count|
          bp = BloodPressure.new(systolic: systolic_value, diastolic: diastolic[count - 1])
          sesh = Session::Closed.new
          sesh.document[observations].blood_pressure = bp
          @sessions << sesh
        end
      end

      subject(:audit) { SessionStatistics.new(@sessions) }
      it { is_expected.to be_a(Renalware::HD::SessionStatistics) }

      # Most of the mean calculations use this strategy class
      # so we test all possible edge cases here.
      describe SessionStatistics::MeanValueStrategy do
        subject(:strategy) { SessionStatistics::MeanValueStrategy }

        it "calculates the mean from a number of values" do
          sessions = [ { x: 1.1 }, { x: 1.2 }, { x: 1.3 } ]
          selector = ->(session) { session[:x] }
          result = strategy.new(sessions: sessions, selector: selector).call
          expect(result).to eq(1.2)
        end

        it "returns the only value if there is just one" do
          sessions = [ { x: 1.99999 }]
          selector = ->(session) { session[:x] }
          result = strategy.new(sessions: sessions, selector: selector).call
          expect(result).to eq(2.0) # 1.9999 rounded up to 2.0
        end

        it "excludes nil values from the mean calculation" do
          sessions = [ { x: 1.1 }, { x: 1.2 }, { x: nil }, { x: 1.3 } ]
          selector = ->(session) { session[:x] }
          result = strategy.new(sessions: sessions, selector: selector).call
          expect(result).to eq(1.2)
        end

        it "returns 0 if there are sessions" do
          selector = ->(session) { session[:x] }
          result = strategy.new(sessions: [], selector: selector).call
          expect(result).to eq(0)
        end

        it "returns 0 if there are only nil values" do
          sessions = [{ x: nil }, { x: nil }]
          selector = ->(session) { session[:x] }
          result = strategy.new(sessions: sessions, selector: selector).call
          expect(result).to eq(0)
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

      describe "Blood pressure extents" do
        let(:highest_systolic_bp) { BloodPressure.new(systolic: 200, diastolic: 100) }
        let(:lowest_systolic_bp)  { BloodPressure.new(systolic: 100, diastolic: 100) }
        let(:unmatched_bp)        { BloodPressure.new(systolic: 150, diastolic: 100) }
        before do
          @sessions = [
            Session::Closed.new.tap do |session|
              session.document.observations_before.blood_pressure = unmatched_bp
              session.document.observations_after.blood_pressure = lowest_systolic_bp
            end,
            Session::Closed.new.tap do |session|
              session.document.observations_before.blood_pressure = unmatched_bp
              session.document.observations_after.blood_pressure = unmatched_bp
            end,
            Session::Closed.new.tap do |session|
              session.document.observations_before.blood_pressure = highest_systolic_bp
              session.document.observations_after.blood_pressure = unmatched_bp
            end
          ]
        end

        describe "lowest_systolic_blood_pressure" do
          it "returns a BloodPressure object" do
            bp = audit.lowest_systolic_blood_pressure

            expect(bp).to be(lowest_systolic_bp)
          end
        end

        describe "highest_systolic_blood_pressure" do
          it "returns a BloodPressure object" do
            bp = audit.highest_systolic_blood_pressure

            expect(bp).to be(highest_systolic_bp)
          end
        end
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

          # effective weight loss = [3, 2, 1] so the mean = 1.99999 rounded to 2 places
          expect(audit.mean_weight_loss).to eq(2.0)
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

      describe "#mean_litres_processed" do
        it "calculates the mean value of dialysis flow rate" do
          @sessions = [5.1, 10.2, 15.3].map do |litres_processed| # a rate
            Session::Closed.new.tap do |session|
              session.document.dialysis.litres_processed = litres_processed
            end
          end

          expect(audit.mean_litres_processed).to eq(10.2)
        end
      end

      # waiting for #839
      describe "dialysis_time_shortfall" do
        it "returns the number of minutes of missed HD time across the sessions "\
           " which is to say total expected - totl actual time on HD " do
          pending
          fail
        end
      end

      # waiting for #939
      describe "#number_of_missed_sessions" do

        it "returns the number of dna sessions" do
          pending
          @sessions = [
            Session::Closed.new,
            Session::DNA.new,
            Session::Closed.new,
            Session::DNA.new
          ]
          expect(audit.number_of_missed_sessions).to eq(2)
        end
      end
    end
  end
end
