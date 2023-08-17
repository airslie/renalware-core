# frozen_string_literal: true

module Renalware
  module Hospitals
    class Ward < ApplicationRecord
      belongs_to :hospital_unit, class_name: "Hospitals::Unit", inverse_of: :wards

      validates :hospital_unit, presence: true
      validates :name, presence: true, uniqueness: { scope: :hospital_unit_id }

      scope :ordered, -> { order(:name) }
      scope :active, -> { where(active: true) }

      def to_s = name
    end
  end
end
