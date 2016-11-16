require "rails_helper"

module Renalware
  module PD
    describe APDRegime, type: :model do
      describe "validations" do
        it do
          is_expected.to validate_numericality_of(:last_fill_volume)
                     .is_greater_than_or_equal_to(500)
                     .is_less_than_or_equal_to(5000)
        end

        it do
          is_expected.to validate_numericality_of(:tidal_percentage)
                     .is_greater_than_or_equal_to(0)
                     .is_less_than_or_equal_to(100)
        end

        it do
          is_expected.to validate_numericality_of(:no_cycles_per_apd)
                     .is_greater_than_or_equal_to(2)
                     .is_less_than_or_equal_to(20)
        end

        it do
          is_expected.to validate_numericality_of(:overnight_pd_volume)
                     .is_greater_than_or_equal_to(3000)
                     .is_less_than_or_equal_to(25000)
        end

        it do
          is_expected.to validate_numericality_of(:therapy_time)
                     .is_greater_than_or_equal_to(PD::APDRegime::VALID_THERAPY_TIMES.first)
                     .is_less_than_or_equal_to(PD::APDRegime::VALID_THERAPY_TIMES.last)
        end

        it do
          is_expected.to validate_numericality_of(:fill_volume)
                     .is_less_than_or_equal_to(2500)
        end
      end
    end
  end
end
