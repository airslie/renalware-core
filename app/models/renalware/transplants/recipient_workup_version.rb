module Renalware
  module Transplants
    class RecipientWorkupVersion < Version
      self.table_name = "transplants_recipient_workup_versions"
      default_scope { where.not(event: 'create') }
    end
  end
end
