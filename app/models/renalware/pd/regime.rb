require_dependency "renalware/pd"

module Renalware
  module PD
    class Regime < ActiveRecord::Base
      VALID_RANGES = OpenStruct.new(
        delivery_intervals: [1, 2, 4, 8]
      )

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :system

      has_many :bags, class_name: "Renalware::PD::RegimeBag"
      has_many :bag_types, through: :bags
      has_one :termination,
               class_name: "RegimeTermination",
               dependent: :delete,
               inverse_of: :regime

      accepts_nested_attributes_for :bags, allow_destroy: true

      validates :delivery_interval,
                allow_nil: true,
                numericality: { only_integer: true },
                inclusion: { in: VALID_RANGES.delivery_intervals }
      validates :patient, presence: true
      validates :start_date, presence: true, timeliness: { type: :date }
      validates :end_date,
                timeliness: { type: :date, on_or_after: ->(regime) { regime.start_date } },
                allow_nil: true
      validates :treatment, presence: true
      validate :min_one_bag

      scope :current, -> { eager_load(:termination).where(terminated_on: nil).first }
      scope :with_bags, -> { eager_load(bags: [:bag_type]) }

      def self.current
        Regime.order("pd_regimes.created_at DESC").limit(1).with_bags.first
      end

      def current?
        Regime.current == self
      end

      def terminated?
        termination.present?
      end

      def self.policy_class
        RegimePolicy
      end

      def apd?
        pd_type == :apd
      end

      def capd?
        pd_type == :capd
      end

      def pd_type
        raise NotImplementedError
      end

      def has_additional_manual_exchange_bag?
        false
      end

      def deep_dup
        regime = dup
        regime.bags = bags.map(&:dup)
        regime
      end

      def deep_restore_attributes
        restore_attributes
        bags.reload
        with_bag_destruction_marks_removed
      end

      # changed_for_autosave? is an AR method that will recursively check the in-memory
      # regime and its bags for changes or any bags marked for destruction.
      def anything_changed?
        changed_for_autosave?
      end

      def with_bag_destruction_marks_removed
        bags.select(&:marked_for_destruction?).each(&:reload)
        self
      end

      def terminate(by:, terminated_on: Date.current)
        build_termination(by: by, terminated_on: terminated_on)
        self
      end

      attr_accessor :total_potential_fluid_available_for_overnight_exchanges

      private

      def min_one_bag
        bags_marked_for_destruction = bags.select(&:marked_for_destruction?)
        remaining_bags = bags - bags_marked_for_destruction
        errors.add(:regime, "must be assigned at least one bag") if remaining_bags.empty?
      end

    end
  end
end
