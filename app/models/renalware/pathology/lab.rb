# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Lab < ApplicationRecord
      UNKNOWN_LAB_NAME = "Lab: Unknown"

      has_many :request_descriptions, class_name: "RequestDescription"

      scope :ordered, -> { order(name: :asc) }

      validates :name, presence: true

      def self.unknown
        find_by!(name: UNKNOWN_LAB_NAME)
      end
    end
  end
end
