# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class LetterPolicy < BasePolicy
      alias_attribute :letter, :record

      def author?
        has_write_privileges?
      end

      def update?
        false
      end

      def submit_for_review?
        false
      end

      def reject?
        false
      end

      def approve?
        false
      end

      def complete?
        false
      end

      def destroy?
        record.state.downcase.to_sym != :approved
      end
    end
  end
end
