# frozen_string_literal: true

module Renalware
  module Legacy
    class LetterPolicy < BasePolicy
      def create? = false
      def update? = false
      def destroy? = false
      def edit? = false
      def new? = false
    end
  end
end
