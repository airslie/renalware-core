require_dependency "renalware/pd"

module Renalware
  module PD
    class Regime < ActiveRecord::Base

      before_save :set_glucose_volume_percent_1_36
      before_save :set_glucose_volume_percent_2_27
      before_save :set_glucose_volume_percent_3_86

      belongs_to :patient, class_name: "Renalware::Patient"

      has_many :regime_bags
      has_many :bag_types, through: :regime_bags

      accepts_nested_attributes_for :regime_bags, allow_destroy: true

      scope :current, -> { order("created_at DESC").limit(1) }

      validates :patient, presence: true
      validates :start_date, presence: true
      validates :treatment, presence: true
      validate :min_one_regime_bag

      def apd?
        false
      end

      private

      def min_one_regime_bag
        errors.add(:regime, "must be assigned at least one bag") if regime_bags.empty?
      end

      def match_bag_type
        glucose_types = [[], [], []]

        regime_bags.each do |bag|
          weekly_total = bag.weekly_total_glucose_ml_per_bag
          glucose_content = bag.bag_type.glucose_content.to_f
          case glucose_content
          when 13.6 then glucose_types[0] << weekly_total
          when 22.7 then glucose_types[1] << weekly_total
          when 38.6 then glucose_types[2] << weekly_total
          else glucose_types
          end
        end
        glucose_types
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
