require_dependency "renalware/pd"

module Renalware
  module PD
    class CAPDRegime < Regime
      include OrderedScope
      include PatientScope

      before_save :set_glucose_volume_percent_1_36
      before_save :set_glucose_volume_percent_2_27
      before_save :set_glucose_volume_percent_3_86

      def pd_type
        :capd
      end

      private

      def match_bag_type
        @match_bag_type ||= begin
          glucose_types = [[], [], []]

          bags.each do |bag|
            weekly_total = bag.weekly_total_glucose_ml_per_bag
            glucose_content = bag.bag_type.glucose_content.to_f
            case glucose_content
            when 1.36 then glucose_types[0] << weekly_total
            when 2.27 then glucose_types[1] << weekly_total
            when 3.86 then glucose_types[2] << weekly_total
            else glucose_types
            end
          end
          glucose_types
        end
      end

      def set_glucose_volume_percent_1_36
        if match_bag_type[0].empty?
          0
        else
          per_week_total = match_bag_type[0].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_percent_1_36 = glucose_daily_average.round
        end
      end

      def set_glucose_volume_percent_2_27
        if match_bag_type[1].empty?
          0
        else
          per_week_total = match_bag_type[1].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_percent_2_27 = glucose_daily_average.round
        end
      end

      def set_glucose_volume_percent_3_86
        if match_bag_type[2].empty?
          0
        else
          per_week_total = match_bag_type[2].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total / 7.to_f
          self.glucose_volume_percent_3_86 = glucose_daily_average.round
        end
      end
    end
  end
end
