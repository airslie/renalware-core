require_dependency "renalware/renal"

module Renalware
  module Renal
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :profile
    end
  end
end
