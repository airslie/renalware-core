require "rails_helper"

module Renalware
  module HD
    describe SessionStatistics, focus: true do
      #let(:patient) { build_stubbed(:hd_patient) }
      subject(:audit) { SessionStatistics.new(@sessions) }

      it { is_expected.to be_a(Renalware::HD::SessionStatistics) }

      describe "Mean blood pressure" do

        def stub_sessions(observations:, systolic_range:, diastolic_range:)
          systolic = *systolic_range
          diastolic = *diastolic_range
          fail unless systolic.count == diastolic.count

          @sessions = []
          systolic.each_with_index do |systolic, count|
            bp = BloodPressure.new(systolic: systolic, diastolic: diastolic[count - 1])
            @sessions << double(observations => OpenStruct.new(blood_pressure: bp ))
          end

          # allow(SessionStatistics::QueryableSession)
          #   .to receive(:auditable_sessions_for)
          #   .with(patient)
          #   .and_return(sessions)
        end

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

        it "the mean value is the session value when there is only one session" do
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
      end
    end
  end
end
