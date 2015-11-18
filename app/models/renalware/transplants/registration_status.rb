require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RegistrationStatus < ActiveRecord::Base
      include Accountable

      belongs_to :description, class_name: "RegistrationStatusDescription"

      scope :ordered, -> { order(started_on: :asc) }
      scope :reversed, -> { order(started_on: :desc) }

      validates :description_id, presence: true
      validates :started_on, timeliness: { type: :date, allow_blank: false }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }

      validate :constraint_started_on_today_or_before, if: :started_on

      def terminated?
        terminated_on.present?
      end

      def constraint_started_on_today_or_before
        errors.add(:started_on, :invalid) if started_on > Time.zone.today
      end

      def to_s
        description.to_s if description
      end
    end
  end
end
