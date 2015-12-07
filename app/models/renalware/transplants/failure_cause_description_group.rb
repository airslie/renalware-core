require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class FailureCauseDescriptionGroup < ActiveRecord::Base
      has_many :descriptions, class_name: "FailureCauseDescription", foreign_key: "group_id"

      def ordered_descriptions
        descriptions.ordered
      end

      def to_s
        name
      end
    end
  end
end
