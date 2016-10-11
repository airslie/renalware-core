require "rails_helper"

module Renalware
  module HD
    describe "Closed Session" do
      describe Session::Closed, type: :model do
        it { is_expected.to validate_presence_of(:signed_off_by) }
        it { is_expected.to validate_presence_of(:end_time) }
        it "defines a policy class" do
          expect(Session::Closed.policy_class).to eq(ClosedSessionPolicy)
        end
      end

      describe Session::Closed::SessionDocument do
        subject(:document) { Session::Closed::SessionDocument.new }

        [:hdf_pre, :hdf_post].each do |hd_type|
          it "validates presence of #hdf if hd_type is hdf" do
            document.info.hd_type = hd_type
            document.valid?
            expect(document.hdf.errors).to include(:subs_fluid_pct,
                                                   :subs_goal,
                                                   :subs_rate,
                                                   :subs_volume)
          end
        end

        it "does not validate presence of hdf if hd_type is HD" do
          document.info.hd_type = :hd
          document.valid?
          expect(document.hdf.errors).to_not include(:subs_fluid_pct)
        end
      end

      describe Session::Closed::SessionDocument::Info do
        it { is_expected.to validate_presence_of(:hd_type) }
      end

      describe Session::Closed::SessionDocument::Observations do
        subject(:observations) {
          Session::Closed::SessionDocument::Observations.new(blood_pressure: BloodPressure.new)
        }

        context "validation" do
          it { is_expected.to validate_presence_of(:pulse) }

          it { is_expected.to_not validate_presence_of(:bm_stix) }
          it { is_expected.to validate_presence_of(:weight_measured) }
          it { is_expected.to validate_presence_of(:temperature_measured) }

          it "validates presence of blood_pressure" do
            expect(observations).to_not be_valid
            expect(observations.blood_pressure.errors).to include(:systolic, :diastolic)
          end

          context "#weight" do
            it "validate weight when weight_measured is true" do
              observations.weight_measured = :yes
              expect(observations).to validate_presence_of(:weight)
            end

            it "does not validate weight when weight_measured is false" do
              observations.weight_measured = :no
              expect(observations).to_not validate_presence_of(:weight)
            end
          end

          context "#temperature" do
            it "validate temperature when temperature_measured is true" do
              observations.temperature_measured = :yes
              expect(observations).to validate_presence_of(:temperature)
            end

            it "does not validate temperature when weight_measured is false" do
              observations.temperature_measured = :no
              expect(observations).to_not validate_presence_of(:temperature)
            end
          end
        end
      end
    end
  end
end
