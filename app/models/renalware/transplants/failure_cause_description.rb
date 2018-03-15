# frozen_string_literal: true

require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class FailureCauseDescription < ApplicationRecord
      belongs_to :group, class_name: "FailureCauseDescriptionGroup", foreign_key: "group_id"

      scope :ordered, -> { order(name: :asc) }

      validates :name, presence: true

      def to_s
        name
      end
    end
  end
end
