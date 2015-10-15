module Renalware
  module Transplants
    class DonorWorkupVersion < Version
      default_scope { where.not(event: "create") }
    end
  end
end
