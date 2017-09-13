require_dependency "renalware/hd/base_controller"

# The route to the edit route for this controller takes /:year/:week_number segments
# rather than an id. THat is because when we load the diary, and when we navigate back and forth
# through diaries, we are concerned with the week more then an id. Its easier to navigate to the
# next week with /2017/52 than by looking up the id of the next diary ahead of time.
module Renalware
  module HD
    class DiariesController < BaseController
      def edit
        authorize weekly_diary, :show?
        render locals: {
          diary_form: DiaryForm.new(weekly_diary),
          diary: DiaryPresenter.new(current_user, weekly_diary),
          week_period: week_period
        }
      end

      private

      def weekly_diary
        @weekly_diary ||= begin
          FindOrCreateDiaryByWeekQuery.new(
            relation: WeeklyDiary.eager_load(
                slots: [:patient, :station, :diurnal_period_code],
                master_diary: { slots: [:patient, :station, :diurnal_period_code] }
                ),
            unit_id: unit_id,
            week_period: week_period,
            by: current_user
          ).call
        end
      end

      # The route segments are /:year/:week_number
      # We use a WeekPeriod value object to wrap those two things.
      def week_period
        WeekPeriod.new(
          week_number: params[:week_number],
          year: params[:year]
        )
      end

      def unit_id
        params[:unit_id]
      end
    end
  end
end
