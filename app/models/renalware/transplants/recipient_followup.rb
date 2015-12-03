require_dependency "renalware/transplants"
require "document/base"

module Renalware
  module Transplants
    class RecipientFollowup < ActiveRecord::Base
      include Document::Base
      extend Enumerize

      belongs_to :operation, class_name: "RecipientOperation", foreign_key: "operation_id"

      has_paper_trail class_name: "Renalware::Transplants::Version"
      has_document class_name: "Renalware::Transplants::RecipientFollowupDocument"

      def self.for_operation(operation)
        where(operation: operation)
      end
    end
  end
end
