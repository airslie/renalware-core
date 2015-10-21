module Renalware
  class LeftRightConfirmation < NestedAttribute
    attribute :left, enums: %i(yes no)
    attribute :right, enums: %i(yes no)
  end
end