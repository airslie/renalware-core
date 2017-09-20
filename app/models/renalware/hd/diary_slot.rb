require_dependency "renalware/hd"

module Renalware
  module HD
    class DiarySlot < ApplicationRecord
      # Changing to_ary from private to public here is a hack required to remove a SimpleDelgator
      # warning in eg Renalware::HD::WeeklyDiary::WeeklySlotDecorator:
      #
      #   `respond_to?': delegator does not forward private method #to_ary
      #
      # Yielding a slot from DiaryPresenter to the view seems to want to call #to_ary on it, (have
      # not looked into why) and as the slot is wrapped in a decorator using SimpleDelegator,
      # SimpleDelegatr complains it can't delegate to a private method.
      # An alternative is to define the following in each Slot decorator
      #
      #    def respond_to?(method, include_private = false)
      #      return false if method == :to_ary
      #      super
      #    end
      #
      #  or to use method_missnig instead of SimpleDelegator in Slot Decorators.
      #
      public :to_ary

      include Accountable
      belongs_to :diary, class_name: "Renalware::HD::Diary"
      belongs_to :patient
      belongs_to :station, class_name: "Renalware::HD::Station"
      belongs_to :diurnal_period_code

      validates :diary, presence: true
      validates :patient, presence: true
      validates :station, presence: true
      validates :diurnal_period_code, presence: true
      validates :day_of_week, presence: true, inclusion: { in: 1..7 }

      scope :weekly, -> { joins(:diary).where(hd_diaries: { master: false }) }
      scope :archived, ->{ weekly.where(archived: true) }
      scope :unarchived, ->{ weekly.where(archived: false) }

      # A patient can only be assigned to one station in any period (e.g. am)/day combination
      # for a diary. I.e. they can't be on two stations on Monday morning.
      validates :patient_id,
                uniqueness: { scope: [:diary, :diurnal_period_code, :day_of_week] }

      delegate :id, to: :diary, prefix: true

      def self.policy_class
        DiaryPolicy
      end

      def description
        period = diurnal_period_code.code.upcase # e.g. AM
        if diary.master
          "Recurring every #{day_of_week_name} #{period}"
        else
          "This week only on #{day_of_week_name} #{period}"
        end
      end

      def day_of_week_name
        Time::DAYS_INTO_WEEK.keys[day_of_week - 1].capitalize
      end

      def cell_id
        "#{diurnal_period_code&.id}-#{station&.id}-#{day_of_week}"
      end
    end
  end
end
