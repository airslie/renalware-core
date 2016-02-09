module Renalware
  module HD
    class SessionPresenter < DumbDelegator
      attr_reader :preference_set

      def initialize(session)
        super(session)
      end

      def start_time
        ::I18n.l(super, format: :time)
      end

      def end_time
        ::I18n.l(super, format: :time)
      end
    end
  end
end
