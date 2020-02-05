# frozen_string_literal: true

module Renalware
  module Letters
    class LettersInProgressComponent < ApplicationComponent
      attr_reader :current_user

      def initialize(current_user:)
        @current_user = current_user
      end

      # Note we want oldest letters ordered first here - elsewhere letters are newest first
      def letters_in_progress
        @letters_in_progress ||= begin
          present_letters(
            Letters::Letter
              .reversed
              .where("author_id = ? or created_by_id = ?", current_user.id, current_user.id)
              .in_progress
              .includes(:author, :patient, :letterhead)
          )
        end
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
