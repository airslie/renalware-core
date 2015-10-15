module Renalware
  class LeftRightConfirmation < Document::Embedded
    attribute :left, enums: :yes_no
    attribute :right, enums: :yes_no
  end
end