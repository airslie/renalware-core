# frozen_string_literal: true

module Renalware
  module Letters::Transports::Mesh
    class Transmission < ApplicationRecord
      include RansackAll
      belongs_to :letter, class_name: "Letters::Letter"
      has_many :operations, -> { order(created_at: :asc) }, dependent: :destroy
      validates :letter, presence: true

      def self.policy_class
        BasePolicy
      end

      def successful_inf_and_bus_responses?
        [
          operations.to_a.detect { |op| op.success? && op.itk3_infrastructure_response? },
          operations.to_a.detect { |op| op.success? && op.itk3_business_response? }
        ].compact.length == 2
      end

      ransacker :created_at, type: :date do
        Arel.sql("date(created_at)")
      end
    end
  end
end
