module Renalware
  module HD
    class DNASessionPolicy < BasePolicy
      def destroy?
        edit?
      end

      def edit?
        record.persisted? and not record.immutable?
      end
    end
  end
end
