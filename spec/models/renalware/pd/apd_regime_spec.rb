require "rails_helper"

module Renalware
  module PD
    describe APDRegime, type: :model do
      describe "validations" do
        it { is_expected.to validate_numericality_of(:last_fill_volume) }
        it { is_expected.to validate_numericality_of(:additional_manual_exchange_volume) }
        it { is_expected.to validate_numericality_of(:tidal_percentage) }
        it { is_expected.to validate_numericality_of(:no_cycles_per_apd) }
        it { is_expected.to validate_numericality_of(:overnight_pd_volume) }
        it { is_expected.to validate_numericality_of(:therapy_time) }
        it { is_expected.to validate_numericality_of(:fill_volume) }

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

        it "overnight_pd_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:overnight_pd_volume,
                                   APDRegime::VALID_RANGES.overnight_pd_volumes)
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

        describe "#has_additional_manual_exchange_bag?" do
          it "returns true if at least one bag is an additional_manual_exchange" do
            regime = build(:apd_regime)
            regime.bags << build(:pd_regime_bag, role: :additional_manual_exchange)
            regime.bags << build(:pd_regime_bag, role: :ordinary_bag)

            expect(regime.has_additional_manual_exchange_bag?).to eq(true)
          end

          it "returns false if no bags are an additional_manual_exchange" do
            regime = build(:apd_regime)
            regime.bags << build(:pd_regime_bag, role: :ordinary_bag)
            regime.bags << build(:pd_regime_bag, role: :last_fill)

            expect(regime.has_additional_manual_exchange_bag?).to eq(false)
          end
        end
      end
    end
  end
end
