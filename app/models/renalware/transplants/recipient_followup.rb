require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientFollowup < ActiveRecord::Base
      include Document::Base
      extend Enumerize

      belongs_to :operation, class_name: "RecipientOperation", foreign_key: "operation_id"
      belongs_to :transplant_failure_cause_description,
        class_name: "Transplants::FailureCauseDescription",
        foreign_key: "transplant_failure_cause_code",
        primary_key: "code"

      before_validation :clear_blank_values

      has_paper_trail class_name: "Renalware::Transplants::Version"
      has_document class_name: "Renalware::Transplants::RecipientFollowupDocument"

      validates :stent_removed_on, timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on, timeliness: { type: :date, allow_blank: true }

      def self.for_operation(operation)
        where(operation: operation)
      end

      private

      def clear_blank_values
        self.transplant_failure_cause_code = nil if transplant_failure_cause_code.blank?
      end
    end
  end
end
