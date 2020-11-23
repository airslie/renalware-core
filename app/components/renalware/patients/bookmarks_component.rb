# frozen_string_literal: true

module Renalware
  module Patients
    class BookmarksComponent < ApplicationComponent
      pattr_initialize [:current_user!]

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
