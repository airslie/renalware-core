require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Profile < ActiveRecord::Base
      include Accountable
      extend Enumerize

      belongs_to :patient
      belongs_to :type, class_name: "Type"
      belongs_to :site, class_name: "Site"
      belongs_to :plan, class_name: "Plan"
      belongs_to :decided_by, class_name: "User", foreign_key: "decided_by_id"

      has_paper_trail class_name: "Renalware::Accesses::Version"

      scope :ordered, -> { order(formed_on: :desc) }
      scope :current, -> { where(
        "started_on <= :date AND (terminated_on IS NULL OR terminated_on > :date)",
        date: Time.zone.today) }
      scope :past_and_future, -> { where(
        "started_on > :date OR started_on IS NULL OR (terminated_on IS NOT NULL AND terminated_on <= :date)",
        date: Time.zone.today) }

      validates :type, presence: true
      validates :site, presence: true
      validates :side, presence: true
      validates :formed_on, presence: true
      validates :planned_on, presence: true, if: :plan
      validates :decided_by, presence: true, if: :plan
      validates :formed_on, timeliness: { type: :date, allow_blank: false }
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }
      validates :planned_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)
    end
  end
end
