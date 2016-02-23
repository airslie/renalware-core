module Renalware
  module HD
    class SessionPresenter < DumbDelegator
      attr_reader :preference_set

      def ongoing_css_class
        signed_off? ? "done" : "active"
      end

      def performed_on
        ::I18n.l(super)
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
