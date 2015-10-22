module Renalware
  class InfectionStatus < NestedAttribute
    attribute :value, enums: %i(negative positive test_result_awaited not_tested unknown)
  end
end