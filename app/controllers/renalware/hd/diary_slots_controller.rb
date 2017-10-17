# rubocop:disable Metrics/ClassLength
require_dependency "renalware/hd/base_controller"

module Renalware
  module HD
    class DiarySlotsController < BaseController

      # GET html -  renders a form
      # Here we will have been passed in the query string:
      # - the unit id
      # - the dirunal_period_code id
      # - the week and year (and thus the diary)
      # and from that lot we could look up the master and weekly diaries
      def new
        # Be default this assume we are going to add a slot to the weekly diary
        # but in which button is clicked in the modal dialog determines which diary
        # (master or weekly) the slot will be added to.
        slot = DiarySlot.new(
          diary: weekly_diary,
          station_id: params[:station_id],
          day_of_week: params[:day_of_week],
          diurnal_period_code_id: params[:diurnal_period_code_id]
        )
        authorize slot
        render locals: locals_for(slot), layout: false
      end

      # POST create js
      # Here we may be adding a slot to the weekly or master diary.
      # That should be transparent to us - we make the change and render
      # create.js.erb which, on the client, will cause an ajax js call to #show. That secondary call
      # is the one that refreshes the slot in the table with its latest state.
      # We do this to avoid having to to a check (in each action in this controller) to see if we
      # are on the master or weekly diary; if we always refresh the diary slot in the ui after any
      # action, then it will always update correctly.
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

      # GET .js refresh a slot in a *weekly* diary
      # See comment on #create.
      # See show.js.erb where we refresh the slot in the diary
      # To get here we will have manufactured a url like this
      #   hd/diaries/2/slots/day/1/period/1/station/1
      # as those bit are will we know.
      # Basically we are saying find for this weekly diary, find the matching
      # slot for the station/day/period combo and render the weekly slot if there is
      # one, or the master behind it if there is one of those, otherwise render an Add button.
      def show
        authorize DiarySlot, :show?
        slot = weekly_then_master_then_empty_slot
        render layout: false, locals: { slot: DiarySlotPresenter.new(slot) }
      end

      def edit
        authorize slot
        render layout: false, locals: { slot: DiarySlotPresenter.new(slot) }
      end

      # DELETE js
      # Delete the slot (we don't know if its on the master or weekly diary).
      # NB as per #create and #update, the rendered js file (destroy.js.erb) will make a secondary
      # back into #show to refresh the UI (i.e. we don't attempt to update the UI in destroy.js.erb)
      def destroy
        authorize slot
        slot.destroy!
        render locals: { slot: DiarySlotPresenter.new(slot) }
      end

      # PATCH js
      # See also comments in #create and #destroy.
      def update
        authorize slot
        slot.patient_id = slot_params[:patient_id]
        slot.save_by!(current_user)
        diary = slot.diary
        render locals: { diary: diary, slot: diary.decorate_slot(slot) }
      end

      private

      # Find the corresponding slot in the master if there is one, otherwise an empty slot
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

      # In the modal dialog that submits the patient_id there are several (select2) dropdown
      # a user can use to choose the patient. Each one has the name patient_id[] so they are
      # submitted in the form as an array. However the array can only hold one id value ie we
      # might get posted patient_id: ["", "123", ""] but never  ["2", "123", ""].
      # Here we reduce that array down to one patient id.
      def posted_patient_id
        patient_ids = Array(slot_params[:patient_id]).reject(&:blank?).uniq
        if patient_ids.length > 1
          raise ArgumentError, "More than one id submitted in patient_id[] : #{patient_ids}"
        end
        patient_ids.first
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
