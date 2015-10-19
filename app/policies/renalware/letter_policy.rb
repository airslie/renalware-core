module Renalware
  class LetterPolicy < BasePolicy

    def author? ; has_write_privileges? end

  end
end