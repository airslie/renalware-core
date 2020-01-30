# frozen_string_literal: true

module Renalware
  module Letters
    class UnreadElectronicCCsComponent < ApplicationComponent
      attr_reader :current_user

      def initialize(current_user:)
        @current_user = current_user
      end

      def unread_electronic_ccs
        @unread_electronic_ccs ||= begin
          receipts = Letters::ElectronicReceipt
            .includes(letter: [:patient, :author, :letterhead])
            .unread
            .for_recipient(current_user.id)
            .order(created_at: :asc)
          CollectionPresenter.new(receipts, Letters::ElectronicReceiptPresenter)
        end
      end
    end
  end
end
