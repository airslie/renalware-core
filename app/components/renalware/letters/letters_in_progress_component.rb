# frozen_string_literal: true

module Renalware
  module Letters
    class LettersInProgressComponent < ApplicationComponent
      def initialize(user:)
        @user = user
      end

      # Note we want oldest letters ordered first here - elsewhere letters are newest first
      def letters_in_progress
        @letters_in_progress ||= begin
          present_letters(
            Letters::Letter
              .reversed
              .where("author_id = ? or created_by_id = ?", user.id, user.id)
              .in_progress
              .includes(:author, :patient, :letterhead)
          )
        end
      end

      def current_user
        user
      end

      # Added this helper as I can't seem to get the Pundit #policy helper to be included
      # in the context when renderingt a component template.
      def policy(record)
        Pundit.policy(user, record)
      end

      private 
      
      attr_reader :user

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
