module Renalware
  module Accesses
    class AccessPresenter < DumbDelegator
      def initialize(access)
        super(access)
      end

      def formed_on
        ::I18n.l(super)
      end

      def started_on
        ::I18n.l(super)
      end

      def terminated_on
        ::I18n.l(super)
      end

      def side
        super.try(:text)
      end
    end
  end
end
