require "rails_helper"

module Renalware
  module PD
    describe APDRegime, type: :model do
      describe "validations" do
        it { is_expected.to validate_numericality_of(:last_fill_volume) }
        it { is_expected.to validate_numericality_of(:additional_manual_exchange_volume) }
        it do
          subject.tidal_indicator = true
          is_expected.to validate_numericality_of(:tidal_percentage)
        end
        it { is_expected.to validate_numericality_of(:no_cycles_per_apd) }
        it { is_expected.to validate_numericality_of(:overnight_volume) }
        it { is_expected.to validate_numericality_of(:daily_volume) }
        it { is_expected.to validate_numericality_of(:therapy_time) }
        it { is_expected.to validate_numericality_of(:fill_volume) }

        it { is_expected.to validate_presence_of(:fill_volume) }
        it { is_expected.to validate_presence_of(:no_cycles_per_apd) }

        describe "#additional_manual_exchange_volume" do
          context "when regime has an additional_manual_exchange bag" do
            it "requires additional_manual_exchange_volume to be specified" do
              allow(subject).to receive(:has_additional_manual_exchange_bag?).and_return(true)
              subject.additional_manual_exchange_volume = nil

              is_expected.to validate_presence_of :additional_manual_exchange_volume
            end
          end
          context "when regime does not have an additional_manual_exchange bag" do
            it "does not expect additional_manual_exchange_volume to be specified" do
              allow(subject).to receive(:has_additional_manual_exchange_bag?).and_return(false)
              subject.additional_manual_exchange_volume = nil

              is_expected.not_to validate_presence_of :additional_manual_exchange_volume
            end
          end
        end

        describe "#last_fill_volume" do
          context "when regime has a last_fill bag" do
            it "requires last_fill_volume to be specified" do
              allow(subject).to receive(:has_last_fill_bag?).and_return(true)
              subject.last_fill_volume = nil

              is_expected.to validate_presence_of :last_fill_volume
            end
          end
          context "when regime does not have a last_fill bag" do
            it "does not expect last_fill_volume to be specified" do
              allow(subject).to receive(:has_last_fill_bag?).and_return(false)
              subject.last_fill_volume = nil

              is_expected.not_to validate_presence_of :last_fill_volume
            end
          end
        end

        describe "#tidal_percentage" do
          it "validates #tidal_percentage when the regime is tidal" do
            subject.tidal_indicator = true
            is_expected.to validate_presence_of :tidal_percentage
          end
          it "doesn't validate #tidal_percentage when the regime is not tidal" do
            subject.tidal_indicator = false
            is_expected.not_to validate_presence_of :tidal_percentage
          end
        end

        def has_numeric_validation(attribute, range)
          subject.send("#{attribute}=".to_sym, range.first - 1)
          subject.valid?
          expected_message = I18n.t(
            "errors.messages.numeric_inclusion",
            from: range.first,
            to: range.last
          )
          subject.errors[attribute].include?(expected_message)

          # clear errors and do with range.last?
        end

        it "tidal_percentage validates numeric_inclusion" do
          subject.tidal_indicator = true
          expect(
            has_numeric_validation(:tidal_percentage,
                                   APDRegime::VALID_RANGES.tidal_percentages)
          ).to eq(true)
        end

        it "no_cycles_per_apd validates numeric_inclusion" do
          expect(
            has_numeric_validation(:no_cycles_per_apd,
                                   APDRegime::VALID_RANGES.cycles_per_apd)
          ).to eq(true)
        end

        it "overnight_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:overnight_volume,
                                   APDRegime::VALID_RANGES.overnight_volumes)
          ).to eq(true)
        end

        it "fill_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:fill_volume,
                                   APDRegime::VALID_RANGES.fill_volumes)
          ).to eq(true)
        end

        it "therapy_time validates numeric_inclusion" do
          expect(
            has_numeric_validation(:therapy_time,
                                    APDRegime::VALID_RANGES.therapy_times)
          ).to eq(true)
        end

        it "last_fill_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:last_fill_volume,
                                   APDRegime::VALID_RANGES.last_fill_volumes)
          ).to eq(true)
        end

        it "additional_manual_exchange_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:additional_manual_exchange_volume,
                                   APDRegime::VALID_RANGES.additional_manual_exchange_volumes)
          ).to eq(true)
        end
      end

      describe "#has_additional_manual_exchange_bag?" do
        it "returns true if at least one bag is an additional_manual_exchange" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :additional_manual_exchange)
          regime.bags << build(:pd_regime_bag, role: :ordinary)

          expect(regime).to have_additional_manual_exchange_bag
        end

        it "returns false if no bags are an additional_manual_exchange" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :ordinary)
          regime.bags << build(:pd_regime_bag, role: :last_fill)

          expect(regime).not_to have_additional_manual_exchange_bag
        end
      end

      describe "#has_last_fill_bag?" do
        it "returns true if at least one bag has the last fill role" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :last_fill)
          regime.bags << build(:pd_regime_bag, role: :ordinary)

          expect(regime).to have_last_fill_bag
        end

        it "returns false if no bags ave the last_fill role" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :ordinary)

          expect(regime).not_to have_last_fill_bag
        end
      end

      describe "callbacks" do
        it "calculates overnight volume before_save" do
          regime = build(:apd_regime)
          regime.bags << build(:pd_regime_bag, role: :ordinary)
          expect_any_instance_of(APD::CalculateVolumes).to receive(:call)

          regime.save!

          expect(regime.overnight_volume).to be > 0
        end
      end
    end
  end
end
