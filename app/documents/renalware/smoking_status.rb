require "document/enum"

module Renalware
  class SmokingStatus < NestedAttribute
    attribute :value,
              Document::Enum,
              enums: %i(non_smoker ex_smoker current)
  end
end
