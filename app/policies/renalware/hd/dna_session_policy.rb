# frozen_string_literal: true

module Renalware
  module HD
    class DNASessionPolicy < BasePolicy
      def destroy?
        edit?
      end

      def edit?
        record.persisted? && !record.immutable?
      end
    end
  end
end
