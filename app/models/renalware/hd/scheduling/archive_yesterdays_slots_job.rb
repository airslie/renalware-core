# frozen_string_literal: true

require "renalware/hd"

# A cron job creates this delayed job, which does the following:
# For all Weekly Diaries in the past, plus this week
# for each day that is in the past
# mark any slots in the weekly diary as archived
# and where the weekly diary is inheriting slots from the master diary
# create corresponding slots in the weekly diary (ie migrate those slots from master to weekly)
# and archive them.
# No slots before the current day (or the up_until: arg) should be touched
#
#
# OK we have a problem,
# If last week there was no weekly diary created... then there is nothing to archive if eg today is
# Monday.
# So really whats the query for finding slots to archive?
# We need to really always inner join onto weekly diaries, and within those for their slots
# select unarchived onces in the past.
# So we MUST always have weekly diaries for every possible week and not rely om a user working the
# UI to create these JIT - because if they don't, unless we have a fn to create missing diaries,
# (from which date?) then we can't query
# So either
# - seed next 10 years (520 per unit)
# - have a fn to generate missing diaries - might be better and safer in the long run?
# - Otherwise after 5 or 10 years or whatever its bound to have caused a problem.

module Renalware
  module HD
    module Scheduling
      class ArchiveYesterdaysSlotsJob < ApplicationJob
        # :reek:UtilityFunction
        def perform(up_until: Time.zone.today - 1.day)
          up_until = up_until.to_date
          create_missing_weekly_diaries
          archive_old_weekly_slots(up_until)
        end

        private

        def archive_old_weekly_slots(up_until)
          slots = DiarySlot
            .unarchived
            .joins(:diary)
            .where(hd_diaries: { year: up_until.year, week_number: up_until.cweek })
            .where(day_of_week: up_until.cwday)

          ids = slots.pluck(:id)
          Rails.logger.info("Archiving #{ids.length} slots up_until #{up_until} with ids #{ids}")
          slots.update_all(archived: true, archived_at: Time.zone.now)
        end

        def create_missing_weekly_diaries
          args = ArchiveArguments.new
          DiaryRange.new(
            from_week_period: args.from_week_period,
            to_week_period: args.to_week_period
          ).create_missing_weekly_diaries_for

          # Start from a point in time perhaps the first slot datetime
          # here is a problem if you remove them from the master diary that will impact the future
          # so we can't do that. We have to leave them in the master, otherwise it affects this week
          # and next week.
          #
          # 1. find the earliest slot datetime and start the query there?
          #

          # A Slot belongs to a diary. It dsoesn't care what the week or date is.
          # The diary defines the week number and year and hence where in the year it is
          # A master diary does not have a concept of time - there is one per hosp unit - unique
          # indexes are in place to enforce this.
          # 1 2 3 4 5 6 7 master
          #   x   x x x
          # 1 2 3 4 5 6 7 weekly
          #     x
          # 1 2 3 4 5 6 7 weekly
          #   x
          # could create a view master where slot and not weekly eqiv
          # mater view
          #
          #
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
end
