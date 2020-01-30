# frozen_string_literal: true

module Renalware
  module Patients
    class BookmarksComponent < ApplicationComponent
      attr_reader :current_user

      def initialize(current_user:)
        @current_user = current_user
      end

      def bookmarks
        @bookmarks ||= begin
          Patients.cast_user(current_user)
            .bookmarks
            .ordered
            .includes(patient: [current_modality: :description])
        end
      end
    end
  end
end
