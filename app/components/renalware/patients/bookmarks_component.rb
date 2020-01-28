# frozen_string_literal: true

module Renalware
  module Patients
    class BookmarksComponent < ApplicationComponent
      def initialize(owner:)
        @owner = owner
      end

      def bookmarks
        @bookmarks ||= begin
          Patients.cast_user(owner)
            .bookmarks
            .ordered
            .includes(patient: [current_modality: :description])
        end
      end

      private 
      
      attr_reader :owner
    end
  end
end
