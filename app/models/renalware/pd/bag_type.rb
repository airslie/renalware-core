require_dependency "renalware/pd"

module Renalware
  module PD
    class BagType < ApplicationRecord
      acts_as_paranoid

      has_many :bags, class_name: "Renalware::PD::RegimeBag"

      validates :manufacturer, presence: true
      validates :description, presence: true
      validates :glucose_content, presence: true

      validates :glucose_content, numericality:
        { allow_nil: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 50 }

      def self.policy_class
        BasePolicy
      end

      def full_description
        [manufacturer, description].join(" ")
      end
    end
  end
end
