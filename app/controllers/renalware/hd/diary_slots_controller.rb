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
        # Be default this assume we are going t add a slot to the weekly diary
        slot = DiarySlot.new(
          assign_to_master_diary_on_creation: false,
          diary: weekly_diary,
          station_id: params[:station_id],
          day_of_week: params[:day_of_week],
          diurnal_period_code_id: params[:diurnal_period_code_id]
        )
        authorize slot
        render locals: locals_for(slot), layout: false
      end

      def create
        slot = current_diary.slots.new(slot_params)
        slot.patient_id = posted_patient_id
        authorize slot
        slot.save_by!(current_user)
        render locals: { diary: current_diary, slot: current_diary.decorate_slot(slot) }
        # TODO: handle validation error
      end

      def show
        authorize slot
        render layout: false, locals: locals_for(slot)
      end

      def destroy
        authorize slot
        slot_id = slot.id
        slot.destroy!
        render layout: false, locals: {
          destroyed_slot_id: slot_id,
          diary: weekly_diary,
          replacement_slot: master_or_empty_slot
        }
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

      def potential_patients_for_current_slot
        PatientsDialysingByDayAndPeriodQuery.new(params[:day_of_week], "am").call.all
      end

      # Find the corresponding slot in the master if there is one, otherwise an empt slot
      # with an 'Add' button ready to set up a new patient
      def master_or_empty_slot
        corresponding_master_slot_for(slot)
      end

      def corresponding_master_slot_for(weekly_slot)
        if slot.on_master_diary?
          # The slot we destroyed was a slot in the master diary so we will render an empty slot
          build_empty_slot_for(weekly_slot)
        else
          # The slot we destroyed was a slot in the weekly diary so we try and get the underlying
          # master slot if there is one. If not, render an empty slot
          master_slot = master_diary.slot_for(
            weekly_slot.diurnal_period_code_id,
            weekly_slot.station_id,
            weekly_slot.day_of_week
          )
          master_slot || build_empty_slot_for(weekly_slot)
        end
      end

      def build_empty_slot_for(weekly_slot)
        NullSlot.new(
          weekly_diary.id,
          weekly_slot.diurnal_period_code_id,
          weekly_slot.station_id,
          weekly_slot.day_of_week
        )
      end

      def slot
        @slot ||= HD::DiarySlot.find(params[:id])
      end

      # In the url the :diary_id param is always the weekly diary id!
      def weekly_diary
        @weekly_diary ||= Diary.find(params[:diary_id])
      end

      def master_diary
        weekly_diary.master_diary
      end

      def current_diary
        @current_diary ||= assign_to_master_diary_on_creation? ? master_diary : weekly_diary
      end

      def assign_to_master_diary_on_creation?
        slot_params[:assign_to_master_diary_on_creation] == "true"
      end

      def locals_for(slot)
        {
          slot: DiarySlotPresenter.new(slot),
          patients: potential_patients_for_current_slot
        }
      end

      def posted_patient_id
        Array(slot_params[:patient_id]).reject(&:blank?).uniq.first
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
