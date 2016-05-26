require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterPolicy < BasePolicy
      def author?; has_write_privileges? end
    end
  end
end
