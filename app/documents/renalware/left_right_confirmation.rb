module Renalware
  class LeftRightConfirmation < NestedAttribute
    attribute :left, enums: :yes_no
    attribute :right, enums: :yes_no
  end
end