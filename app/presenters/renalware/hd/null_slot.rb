require "renalware/hd"

module Renalware
  module HD
    NullSlot = Naught.build do |config|
      config.black_hole
      config.define_explicit_conversions
      config.predicates_return false

      attr_reader :diary_id, :diurnal_period_code_id, :station_id, :day_of_week
      def initialize(diary_id, diurnal_period_code_id, station_id, day_of_week)
        p diurnal_period_code_id
        @diary_id, @diurnal_period_code_id, @station_id, @day_of_week = diary_id, diurnal_period_code_id, station_id, day_of_week
      end

      def master?
        false
      end

      def cell_id
        "#{diurnal_period_code_id}-#{station_id}-#{day_of_week}"
      end
    end
  end
end
