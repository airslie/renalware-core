# frozen_string_literal: true

require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class BatchPolicy < BasePolicy
      def status?
        show?
      end
    end
  end
end
