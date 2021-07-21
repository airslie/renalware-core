# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    module Scheduling
      class MasterDiary < Diary
        # Overwrite the existing master attribute to ensure it defaults to true
        attribute :master, :boolean, default: true
        validates :hospital_unit_id, uniqueness: true
        # rubocop:disable Rails/HasManyOrHasOneDependent
        has_many :weekly_diaries, class_name: "WeeklyDiary"
        # rubocop:enable Rails/HasManyOrHasOneDependent

        # While our DB constraints could check for the string
        # "Renalware::HD::Scheduling::MasterDiary" in the type column, this feels a bit fragile, so
        # instead a MasterDiary must have a corresponding
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

        def slot_for(diurnal_period_code_id, station_id, day_of_week, valid_from: nil)
          (slot = super) && decorate_slot(slot)
        end
      end
    end
  end
end
