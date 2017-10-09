require_dependency "collection_presenter"

# TODO: mixing query and presenter here..
module Renalware
  module HD
    class DiaryPresenter
      attr_reader :user, :weekly_diary, :master_diary, :null_diary
      delegate :id, :hospital_unit_id, :to_s, :week, to: :weekly_diary

      # https://github.com/avdi/naught
      NullDiary = Naught.build do |config|
        config.black_hole
        config.define_explicit_conversions
        config.predicates_return false

        def master?
          false
        end

        def slot_for(diary_id, diurnal_period_code_id, station_id, day_of_week)
          NullSlot.new(diary_id, diurnal_period_code_id, station_id, day_of_week)
        end
      end

      def initialize(user, weekly_diary)
        @user = user
        @weekly_diary = weekly_diary
        @master_diary = weekly_diary.master_diary
        @null_diary = NullDiary.new
      end

      def each_diurnal_period
        DiurnalPeriodCode.all.each do |diurnal_period_code|
          yield(diurnal_period_code) if block_given?
        end
      end

      def each_station
        stations.each_with_index{ |station, index| yield(station, index + 1) if block_given? }
      end

      def each_day(diurnal_period, station)
        (1..last_day_of_week).each do |day_of_week|
          diurnal_period_id = diurnal_period.id
          station_id = station.id
          slot = weekly_diary.slot_for(diurnal_period_id, station_id, day_of_week) ||
                 master_diary.slot_for(diurnal_period_id, station_id, day_of_week) ||
                 null_diary.slot_for(weekly_diary.id, diurnal_period_id, station_id, day_of_week)
          yield(slot) if block_given?
        end
      end

      def day_names
        all_day_names = Time::DAYS_INTO_WEEK.keys
        all_day_names.take(last_day_of_week)
      end

      def stations
        @stations ||= Station.for_unit(hospital_unit_id).ordered.map do |station|
          StationPresenter.new(station)
        end
      end

      def station_locations
        StationLocation.all
      end

      private

      def last_day_of_week
        Renalware.config.include_sunday_on_hd_diaries ? 7 : 6
      end
    end
  end
end
