require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RecipientWorkupVersion < PaperTrail::Version
      self.table_name = :transplants_recipient_workup_versions
    end
  end
end
