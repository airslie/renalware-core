require_dependency "renalware/hd"

module Renalware
  module HD
    class WeeklyDiary < Diary
      # Overwrite the existing master attribute to ensure it defaults to false
      attribute :master, :boolean, default: false
      belongs_to :master_diary, class_name: "Renalware::HD::MasterDiary"
      validates :week_number,
                presence: true,
                uniqueness: { scope: [:year, :hospital_unit_id] },
                inclusion: { in: 1..53 }
      validates :year, presence: true
      validates :master, inclusion: { in: [false], allow_nil: false }
      validates :master_diary, presence: true

      class WeeklySlotDecorator < SimpleDelegator
        def master?
          false
        end
      end

      def decorate_slot(slot)
        WeeklySlotDecorator.new(slot)
      end

      def slot_for(*args)
        (slot = super) && decorate_slot(slot)
      end
    end
  end
end
