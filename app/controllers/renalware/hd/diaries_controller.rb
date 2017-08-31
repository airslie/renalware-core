require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DiariesController < BaseController
      # Want to show current diary by default
      # Could map params[:id] == "current" to look up the current diary.
      # What if the current diary does not exist?
      # We should probably create it.
      # What if previous weeks diaries do not exist?
      # Create JIT or create_missing_diaries() somewhere (and immediately archive them?)
      # Pub sub event would take care of the archiving (monitor creation and editing of diaries?)

      # So here
      # - if 'current' supplied in params[:id], map to a week and year eg week 10, year 2017
      # and look up the period
      def edit
        authorize weekly_diary, :show?
        render locals: {
          diary_form: DiaryForm.new(weekly_diary),
          diary: DiaryPresenter.new(current_user, weekly_diary)
        }
      end

      def update
        authorize diary, :update?
        DiaryForm.new(diary, diary_params).save(by: current_user)
        redirect_to edit_hd_unit_diary_path(unit_id)
      end

      private

      def load_current_diary?
        diary_id == "current"
      end

      def week
        return nil if load_current_diary?
        #WeekPeriod.from_date(Date.parse("2019-01-01"))
      end

      def diary
        WeeklyDiary.find_by!(id: diary_id, hospital_unit_id: unit_id)
      end

       def weekly_diary
        @weekly_diary ||= begin
          # TODO: this current find current week only
          FindOrCreateDiaryByWeekQuery.new(
            relation: WeeklyDiary.includes(slots: :patient, master_diary: { slots: :patient }),
            unit_id: unit_id,
            by: current_user
          ).call
        end
      end

      def diary_id
        params[:id]
      end

      def unit_id
        params[:unit_id]
      end

      def diary_params
        params.require(:diary)
          .permit(:id, periods: [ { stations: [ { slots: [
            :master, :diurnal_period_id, :period_id, :slot_id, :station_id, :patient_id,
            :weekly_period_id, :master_period_id, :day_of_week,
            :_changed, :_destroy
          ]}]}]).to_h
      end
    end
  end
end
