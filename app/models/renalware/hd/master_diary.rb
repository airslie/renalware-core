require_dependency "renalware/hd"

module Renalware
  module HD
    class MasterDiary < Diary
      # Overwrite the existing master attribute to ensure it defaults to true
      attribute :master, :boolean, default: true
      validates :hospital_unit_id, uniqueness: true
      has_many :weekly_diaries, class_name: "Renalware::HD::WeeklyDiary"
      # While out DB constraints could check for the string "Renalware::HD::MasterDiary" in the type
      # column, this feels a bit fragile, so instead a MasterDiary must have a corresponding
      # master = TRUE column
      validates :master, inclusion: { in: [true], allow_nil: false }

      class MasterSlotDecorator < SimpleDelegator
        def master?
          true
        end
      end

      def decorate_slot(slot)
        MasterSlotDecorator.new(slot)
      end

      def slot_for(*args)
        (slot = super) && decorate_slot(slot)
      end
    end
  end
end
