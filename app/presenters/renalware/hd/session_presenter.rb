module Renalware
  module HD
    class SessionPresenter < DumbDelegator
      attr_reader :preference_set

      def initialize(session)
        super(session)
      end
    end
  end
end
