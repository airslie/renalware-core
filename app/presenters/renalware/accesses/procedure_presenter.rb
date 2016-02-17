module Renalware
  module Accesses
    class ProcedurePresenter < DumbDelegator
      def initialize(object)
        super(object)
      end

      def performed_on
        ::I18n.l(super)
      end

      def first_used_on
        ::I18n.l(super)
      end

      def failed_on
        ::I18n.l(super)
      end

      def side
        super.try(:text)
      end
    end
  end
end
