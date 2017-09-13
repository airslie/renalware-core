require_dependency "collection_presenter"

# TODO: mixing query and presenter here..
module Renalware
  module HD
    class DiaryPresenter
      attr_reader :user, :weekly_diary, :master_diary, :null_diary
      delegate :id, :hospital_unit_id, to: :weekly_diary

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

      def each_station(_diurnal_period_code)
        stations.each{ |station| yield(station) if block_given? }
      end

      def each_day(diurnal_period, station)
        Time::DAYS_INTO_WEEK.each do |_day_name, day_of_week|
          day_of_week += 1
          diurnal_period_id, station_id = diurnal_period.id, station.id
          slot = weekly_diary.slot_for(diurnal_period_id, station_id, day_of_week) ||
                 master_diary.slot_for(diurnal_period_id, station_id, day_of_week) ||
                 null_diary.slot_for(weekly_diary.id, diurnal_period_id, station_id, day_of_week)
          yield(slot) if block_given?
        end
      end

      def day_names
        Time::DAYS_INTO_WEEK.keys
      end

      def stations
        @stations ||= Station.for_unit(hospital_unit_id).map do |station|
          StationPresenter.new(station)
        end
      end
    end
  end
end
