require_dependency "renalware/hd"

# A Diary is the schedule of HD Station/Patients assignments for one week for a particular unit.
# A Diary is split into Periods (eg. am pm eve), and each Period has a matrix of slots
# Imagine Days eg 1 to 6 on the X axis and Stations on the Y axis, and into each 'slot' we
# put a patient.
# A patient can only be in one slot in any period.
#
# Do not create instances of this class explicity, always use the STI sub classes eg MasterDiary.
module Renalware
  module HD
    class Diary < ApplicationRecord
      include Accountable

      has_many :slots, class_name: "Renalware::HD::DiarySlot"
      has_many :patients, through: :slots, class_name: "Renalware::HD::Patient"
      validates :hospital_unit_id, presence: true
      validates :master, inclusion: { in: [true, false], allow_nil: true }
      composed_of :week,
                  mapping: [%w(week_number week_number), %w(year year)],
                  constructor: lambda{ |week_number, year|
                    WeekPeriod.new(week_number: week_number, year: year)
                  }

      def self.policy_class
        DiaryPolicy
      end

      # Searchs the object graph rather than a SQL search
      def slot_for(diurnal_period_code_id, station_id, day_of_week)
        slots.find do |slot|
          slot.diurnal_period_code_id == diurnal_period_code_id &&
            slot.station_id == station_id &&
            slot.day_of_week == day_of_week
        end
      end
    end
  end
end
