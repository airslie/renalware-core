# rubocop:disable Metrics/ClassLength
require_dependency "renalware/hd/base_controller"

# Note we always come into this controller with params[:diary_id] which must be a weekly
# diary (never a master. We can add/remove/update slots attached to the weekly's underlying
# master diary, but we will only know that by looking at the para,s for e.g. a 'master' flag.
module Renalware
  module HD
    class DiarySlotsController < BaseController

      # we do know
      # - the unit
      # - the dirunal_period_code
      # - the week and year
      # - (and from that lot we could look up the master and weekly periods)
      # GET html -  renders a form
      def new
        # Be default this assume we are going to add a slot to the weekly diary
        slot = DiarySlot.new(
          diary: weekly_diary,
          station_id: params[:station_id],
          day_of_week: params[:day_of_week],
          diurnal_period_code_id: params[:diurnal_period_code_id]
        )
        authorize slot
        render locals: locals_for(slot), layout: false
      end

      def create
        diary = Diary.find(params[:diary_id])
        slot = diary.slots.new(slot_params)
        slot.patient_id = posted_patient_id
        authorize slot
        if slot.save_by(current_user)
          render locals: { diary: diary, slot: diary.decorate_slot(slot) }
        else
          render :new, locals: { slot: DiarySlotPresenter.new(slot) }, layout: false
        end
      end

      # GET .js refresh a slot in a diary
      # see show.js.erb where we refresh the slot in the diary
      # to get here we will have manufactured a url like this
      #   hd/diaries/2/slots/day/1/period/1/station/1
      # as those bit are wll we know.
      # Basically we are saying find for this weekly diary, find the matching
      # slot for the station/day/period combo and render the weekly slot if there is
      # one of the master behind it, if there is one of those, otherwise render an Add button.
      # Simple huh?
      def show
        authorize DiarySlot, :show?
        slot = weekly_then_master_then_empty_slot
        render layout: false, locals: { slot: DiarySlotPresenter.new(slot) }
      end

      def edit
        authorize slot
        render layout: false, locals: { slot: DiarySlotPresenter.new(slot) }
      end

      def destroy
        authorize slot
        slot.destroy!
        render locals: { slot: DiarySlotPresenter.new(slot) }
      end

      # rubocop:disable Metrics/AbcSize
      def update
        authorize slot
        slot.patient_id = slot_params[:patient_id]
        slot.save_by!(current_user)
        render locals: { diary: slot.diary, slot: slot.diary.decorate_slot(slot) }
      end
      # rubocop:enable Metrics/AbcSize

      private

      # Find the corresponding slot in the master if there is one, otherwise an empt slot
      # with an 'Add' button ready to set up a new patient
      def weekly_then_master_then_empty_slot
        empty_slot = build_empty_weekly_slot
        find_weekly_slot(empty_slot) || find_master_slot(empty_slot) || empty_slot
      end

      def find_master_slot(args)
        slot = master_diary.slots.find_by(
          diurnal_period_code_id: args.diurnal_period_code_id,
          station_id: args.station_id,
          day_of_week: args.day_of_week
        )
        slot && master_diary.decorate_slot(slot)
      end

      def find_weekly_slot(args)
        slot = weekly_diary.slots.find_by(
          diurnal_period_code_id: args.diurnal_period_code_id,
          station_id: args.station_id,
          day_of_week: args.day_of_week
        )
        slot && weekly_diary.decorate_slot(slot)
      end

      # Used for searching etc
      def build_empty_weekly_slot
        weekly_diary.slots.new(
          day_of_week: params[:day_of_week],
          station_id: params[:station_id],
          diurnal_period_code_id: params[:diurnal_period_code_id]
        )
      end

      def slot
        @slot ||= HD::DiarySlot.find(params[:id])
      end

      # In the url the :diary_id param is always the weekly diary id!
      def weekly_diary
        @weekly_diary ||= WeeklyDiary.find(params[:diary_id])
      end

      def master_diary
        weekly_diary.master_diary
      end

      def locals_for(slot)
        {
          slot: DiarySlotPresenter.new(slot),
          weekly_diary: weekly_diary
        }
      end

      def posted_patient_id
        Array(slot_params[:patient_id]).reject(&:blank?).uniq.first
      end

      # Pass master in the query params (not in slot_params) to take an action on the master
      # diary underlying the weekly one
      def add_to_master_diary?
        params.key?(:master)
      end

      def slot_params
        params
          .require(:hd_diary_slot)
          .permit(
            :master_slot,
            :day_of_week,
            :diurnal_period_code_id,
            :station_id,
            :target_diary_id,
            :change_type,
            patient_id: []
            )
      end
    end
  end
end
