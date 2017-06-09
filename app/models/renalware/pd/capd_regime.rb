require_dependency "renalware/pd"

module Renalware
  module PD
    class CAPDRegime < Regime
      include OrderedScope
      include PatientScope

      BAG_VOLUMES = [1000, 1200, 1500, 1800, 2000, 2200, 2500].freeze

      before_save :set_glucose_volume_low_strength
      before_save :set_glucose_volume_medium_strength
      before_save :set_glucose_volume_high_strength

      def pd_type
        :capd
      end

      private

      def match_bag_type
        @match_bag_type ||= begin
          glucose_types = [[], [], []]

          bags.each do |bag|
            weekly_total = bag.weekly_total_glucose_ml_per_bag
            case bag.bag_type.glucose_strength.to_sym
            when :low then glucose_types[0] << weekly_total
            when :medium then glucose_types[1] << weekly_total
            when :high then glucose_types[2] << weekly_total
            else glucose_types
            end
          end
          glucose_types
        end
      end

      def set_glucose_volume_low_strength
        if match_bag_type[0].empty?
          0
        else
          per_week_total = match_bag_type[0].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_low_strength = glucose_daily_average.round
        end
      end

      def set_glucose_volume_medium_strength
        if match_bag_type[1].empty?
          0
        else
          per_week_total = match_bag_type[1].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_medium_strength = glucose_daily_average.round
        end
      end

      def set_glucose_volume_high_strength
        if match_bag_type[2].empty?
          0
        else
          per_week_total = match_bag_type[2].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_high_strength = glucose_daily_average.round
        end
      end
    end
  end
end
