# frozen_string_literal: true

module Renalware
  module Letters
    class UnreadElectronicCCsComponent < ApplicationComponent
      def initialize(user:)
        @user = user
      end

      def unread_electronic_ccs
        @unread_electronic_ccs ||= begin
          receipts = Letters::ElectronicReceipt
            .includes(letter: [:patient, :author, :letterhead])
            .unread
            .for_recipient(user.id)
            .order(created_at: :asc)
          CollectionPresenter.new(receipts, Letters::ElectronicReceiptPresenter)
        end
      end

      private 
      
      attr_reader :user
    end
  end
end
