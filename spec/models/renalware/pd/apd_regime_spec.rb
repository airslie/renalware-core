require "rails_helper"

module Renalware
  module PD
    describe APDRegime, type: :model do
      describe "validations" do
        it { is_expected.to validate_numericality_of(:last_fill_volume) }
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
          expect(has_numeric_validation(:tidal_percentage, APDRegime::VALID_TIDAL_PERCENTAGES))
            .to eq(true)
        end

        it "no_cycles_per_apd validates numeric_inclusion" do
          expect(has_numeric_validation(:no_cycles_per_apd, APDRegime::VALID_CYCLES_PER_APD))
            .to eq(true)
        end

        it "overnight_pd_volume validates numeric_inclusion" do
          expect(
            has_numeric_validation(:overnight_pd_volume, APDRegime::VALID_OVERNIGHT_PD_VOLUMES)
          )
          .to eq(true)
        end

        it "fill_volume validates numeric_inclusion" do
          expect(has_numeric_validation(:fill_volume, APDRegime::VALID_FILL_VOLUMES)).to eq(true)
        end

        it "last_fill_volume validates numeric_inclusion" do
          expect(has_numeric_validation(:last_fill_volume, APDRegime::VALID_LAST_FILL_VOLUMES))
            .to eq(true)
        end

        it "therapy_time validates numeric_inclusion" do
          expect(has_numeric_validation(:therapy_time, APDRegime::VALID_THERAPY_TIMES))
            .to eq(true)
        end
      end
    end
  end
end
