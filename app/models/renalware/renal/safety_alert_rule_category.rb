module Renalware
  module Renal
    class SafetyAlertRuleCategory < ApplicationRecord
      has_many :safety_alert_rules, dependent: :restrict_with_exception

      validates :name, presence: true, uniqueness: true

      scope :ordered, -> { order(:name) }
    end
  end
end
