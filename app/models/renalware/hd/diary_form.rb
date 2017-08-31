require "renalware/hd"

module Renalware
  module HD
    class DiaryForm
      include ActiveModel::Model
      attr_reader :diary, :params

      def initialize(diary, params = {})
        @diary = diary
        @params = params
      end

      class SlotParams
        include Virtus.model(:nullify_blank => true)
        attribute :slot_id, Integer
        attribute :master, Boolean
        attribute :period_id, Integer
        attribute :patient_id, Integer
        attribute :station_id, Integer
        attribute :day_of_week, Integer
        attribute :_destroy, Boolean
        attribute :_changed, Boolean

        def changed?
          slot_id.present? && patient_id.present? && _changed
        end

        def marked_for_deletion?
          slot_id.present? && _destroy
        end

        def added?
          patient_id.present? && slot_id.blank? && station_id.present? && day_of_week.present?
        end

        def added_to_master_diary?
          added? && master
        end

        def added_to_weekly_diary?
          added? && !master
        end

        def status
          return :added_to_master_diary if added_to_master_diary?
          return :added_to_weekly_diary if added_to_weekly_diary?
          return :changed if changed?
          return :marked_for_deletion if marked_for_deletion?
          :no_action
        end
      end


      def save(by:)
        params[:periods].each do |period_id, period|
          period[:stations].each do |station_id, station|
            station[:slots].each do |slot|
              s = SlotParams.new(slot)
              p s.status
            end
          end
        end

        # slots.map{ |slot| p slot; SlotParams.new(slot)}.each do |slot_params|
        #   p slot_params.status
        #   case  slot_params.status
        #   when :changed then change_patient_assigned_to_slot(slot_params, by)
        #   when :marked_for_deletion then destroy_slot(slot_params, by)
        #   when :added_to_master_diary then create_slot_in_master_diary(slot_params, by)
        #   when :added_to_weekly_diary then create_slot_in_weekly_diary(slot_params, by)
        #   end
        # end
      end

      private

      def create_slot_in_master_diary(slot_params, by)
        p "create_slot_in_master_diary"
        raise ArgumentError if slot_params.slot_id.present?
        DiarySlot.create!(
          period_id: slot_params[:master_period_id],
          **slot_params.slice(:patient_id, :station_id, :day_of_week)
        )
      end

       def create_slot_in_weekly_diary(slot_params, by)
        p "create_slot_in_weekly_diary"
        raise ArgumentError if slot_params.slot_id.present?
        DiarySlot.create!(
          period_id: slot_params[:weekly_period_id],
          by: by,
          **slot_params.attributes.slice(:patient_id, :station_id, :day_of_week)
        )
      end

      def destroy_slot(slot_params, by)
        find_slot(slot_params).destroy!
      end

      def change_patient_assigned_to_slot(slot_params, by)
         find_slot(slot_params).update!(patient_id: slot_params.patient_id, by: by)
      end

      def find_slot(slot_params)
        DiarySlot.find_by!(
          id: slot_params.slot_id,
          period_id: slot_params.period_id,
          station_id: slot_params.station_id
        )
      end
    end
  end
end
