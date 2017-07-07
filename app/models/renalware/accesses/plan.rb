require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Plan < ApplicationRecord
      include Accountable
      belongs_to :patient, touch: true
      belongs_to :plan_type
      belongs_to :decided_by, class_name: "User", foreign_key: "decided_by_id"

      validates :plan_type, presence: true
      validates :decided_by, presence: true

      scope :ordered, -> { order(created_at: :desc) }
      scope :current, -> { where(terminated_at: nil) }

      def self.policy_class
        BasePolicy
      end
    end
  end
end
