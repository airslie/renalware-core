# frozen_string_literal: true

module Renalware
  module HD
    class OpenSessionPolicy < BasePolicy
      def destroy?
        edit?
      end

      def edit?
        record.persisted?
      end
    end
  end
end
