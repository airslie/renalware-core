# frozen_string_literal: true

module Renalware
  module Feeds
    class FilePolicy < BasePolicy
      def destroy?
        false
      end

      def edit?
        false
      end

      def update?
        false
      end

      def new
        developer?
      end

      def create
        developer?
      end
    end
  end
end
