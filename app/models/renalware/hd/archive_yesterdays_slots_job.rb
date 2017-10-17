require "renalware/hd"

# A cron job creates this delayed job, which does the following:
# For all Weekly Diaries in the past, plus this week
# for each day that is in the past
# mark any slots in the weekly diary as archived
# and where the weekly diary is inheriting slots from the master diary
# create corresponding slots in the weekly diary (ie migrate thos slots from master to weekly)
# and archive them.
# Not slots before the current day (or the up_until: arg) should be touched
#
#
# OK we have a problem,
# If last week there was no weekly diary created... then there is nothing to archive if eg today is
# Monday.
# So really whats the query for finding slots to archive?
# We need to really always inner join onto weekly diaryies, and within tose for their slots
# select unarchved onces in the past.
# So we MUST always have weekly diaries for every possible week and not rely om a user working te UI
# to create these JIT - because if they don't, unless we have a fn to creatae missing diaries,
# (from which date?) then we can't query
# So either
# - seed next 10 years (520 per unit)
# - have a fn to generate missing diaries - might be better and safer in the long run?
# - Otherwise after 5 or 10 years or whatever its bound to have cased a problem.

module Renalware
  module HD
    class ArchiveYesterdaysSlotsJob < ApplicationJob
      attr_reader :up_until

      # :reek:UtilityFunction
      def perform(up_until: nil)
        @up_until = up_until&.to_date
        @up_until ||= (Time.zone.today - 1.day)

        diary = Diary.find_by(year: @up_until.year, week_number: @up_until.cweek)
        return unless diary

        diary
          .slots
          .unarchived
          .where(day_of_week: @up_until.cwday)
          .update_all(archived: true, archived_at: Time.zone.now)
        # DiarySlot
        #   .unarchived
        #   .joins(:diary)
        #   .where(hd_diaries: { year: up_until.year, week_number: up_until.cweek)

        #   .update_all(archived: true, archived_at: Time.zone.now)
      end

      private

      def create_missing_weekly_diaries
        # intering query
        # basic implemenraiton
        # select all weeklydiaries pluch year week from installation start date??? to now
        # loop through
        #  diary year 2017 week 1
        #  MISSING diary year 2017 week 1 - so create
        #  diary year 2017 week 3
        #  select
      end

    end
  end
end
