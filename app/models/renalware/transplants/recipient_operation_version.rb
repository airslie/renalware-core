require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RecipientOperationVersion < PaperTrail::Version
      self.table_name = :transplants_recipient_operation_versions
    end
  end
end
