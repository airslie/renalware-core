require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DiarySlotsController < BaseController

      # GET html
      # we don't know if its the master or weekly period, not until they specify this in the form
      # we do know
      # - the unit
      # - the dirunal_period_code
      # - the week and year
      # - (and from that lot we could look up the master and weekly periods)
      def new
        slot = DiarySlot.new(
          diary: diary,
          station_id: params[:station_id],
          day_of_week: params[:day_of_week],
          diurnal_period_code_id: params[:diurnal_period_code_id]
        )
        authorize slot
        render locals: locals_for(slot), layout: false
      end

      def create
        slot = diary.slots.new(slot_params)
        authorize slot
        slot.save_by!(current_user)
        render locals: { diary: diary, slot: diary.decorate_slot(slot) }
      end

      def show
        authorize slot
        render layout: false, locals: { slot: slot }
      end

      def destroy
        authorize slot
        slot_id = slot.id
        slot.destroy!
        render layout: false, locals: {
          destroyed_slot_id: slot_id,
          diary: DiaryPresenter::NullDiary.new,
          replacement_slot: replacement_slot
        }
      end

      def update
        authorize slot
        slot.patient_id = slot_params[:patient_id]
        slot.save_by!(current_user)
        render locals: { diary: slot.diary, slot: diary.decorate_slot(slot) }
      end

      private

      # Find the corresponding slot in the master if there is one
      def replacement_slot
        corresponding_master_slot_for(slot)
      end

      def corresponding_master_slot_for(weekly_slot)
        return build_null_slot unless diary.master_diary_id.present?
        diary.master_diary.slot_for(
          weekly_slot.diurnal_period_code_id,
          weekly_slot.station_id,
          weekly_slot.day_of_week
        ) || build_null_slot
      end

      def build_null_slot
        NullSlot.new(0,0,0,0)
      end

      def slot
        @slot ||= diary.slots.find(params[:id])
      end

      def diary
        @diary ||= Diary.find(params[:diary_id])
      end

      def locals_for(slot)
        {
          slot: slot
        }
      end

      def slot_params
        params.require(:hd_diary_slot)
              .permit(:patient_id, :day_of_week, :diurnal_period_code_id, :station_id)
      end
    end
  end
end
