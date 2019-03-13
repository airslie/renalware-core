# frozen_string_literal: true

require_dependency "renalware/dashboard"
require_dependency "collection_presenter"

module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @user = user
      end

      attr_reader :user

      def bookmarks
        @bookmarks ||= begin
          Patients.cast_user(user)
                  .bookmarks
                  .joins(:patient)
                  .merge(patient_scope)
                  .ordered
                  .includes(patient: [current_modality: :description])
        end
      end

      # Note we want oldest letters ordered first on the dashboard - elsewhere letters
      # are newest first
      def letters_in_progress
        @letters_in_progress ||= begin
          present_letters(
            Letters::Letter
              .reversed
              .where("author_id = ? or letter_letters.created_by_id = ?", user.id, user.id)
              .in_progress
              .joins(:patient)
              .merge(patient_scope)
              .includes(:author, :patient, :letterhead)
          )
          # Renalware::Letters.cast_author(user)
        end
      end

      def unread_messages_receipts
        @unread_messages_receipts ||= begin
          receipts = Messaging::Internal.cast_recipient(user)
            .receipts
            .joins(message: :patient)
            .includes(message: [:author, :patient])
            .merge(patient_scope)
            .order("messaging_messages.sent_at asc")
            .unread
          CollectionPresenter.new(receipts, Messaging::Internal::ReceiptPresenter)
        end
      end

      def unread_electronic_ccs
        @unread_electronic_ccs ||= begin
          receipts = Letters::ElectronicReceipt
            .includes(letter: [:patient, :author, :letterhead])
            .unread
            .joins(letter: :patient)
            .merge(patient_scope)
            .for_recipient(user.id)
            .order(created_at: :asc)
          CollectionPresenter.new(receipts, Letters::ElectronicReceiptPresenter)
        end
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end

      def patient_scope
        ::Renalware::Patients::PatientPolicy::Scope.new(user, Patient).resolve
      end
    end
  end
end
