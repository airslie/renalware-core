# frozen_string_literal: true

require_dependency "renalware/letters/letter_policy"

module Renalware
  module Letters
    class ElectronicReceiptPolicy < BasePolicy
      def mark_as_read?
        !record.read? && (record.letter.approved? || record.letter.completed?)
      end

      def unread?
        index?
      end

      def read?
        index?
      end

      def sent?
        index?
      end
    end
  end
end
