module Renalware
  module Transplants
    class RecipientWorkupVersion < Version
      default_scope { where.not(event: "create") }
    end
  end
end
