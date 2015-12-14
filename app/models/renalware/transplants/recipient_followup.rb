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
        foreign_key: "transplant_failure_cause_description_id"

      has_paper_trail class_name: "Renalware::Transplants::Version"
      has_document class_name: "Renalware::Transplants::RecipientFollowupDocument"

      validates :stent_removed_on, timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on, timeliness: { type: :date, allow_blank: true }

      def self.for_operation(operation)
        where(operation: operation)
      end
    end
  end
end
