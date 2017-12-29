require_dependency "renalware/hospitals"

module Renalware
  module Hospitals
    class Ward < ApplicationRecord
      belongs_to :hospital_unit, class_name: "Hospitals::Unit", inverse_of: :wards

      validates :hospital_unit, presence: true
      validates :name, presence: true, uniqueness: { scope: :hospital_unit_id }

      scope :ordered, -> { order(:name) }

      def self.policy_class
        BasePolicy
      end

      def to_s
        name
      end
    end
  end
end
