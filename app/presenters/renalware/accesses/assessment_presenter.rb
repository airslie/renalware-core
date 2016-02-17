module Renalware
  module Accesses
    class AssessmentPresenter < DumbDelegator
      def initialize(object)
        super(object)
      end

      def performed_on
        ::I18n.l(super)
      end

      def procedure_on
        ::I18n.l(super)
      end

      def side
        super.try(:text)
      end

      def outcome
        document.test.outcome.try(:text)
      end

      def next_surveillance_due
        document.admin.next_surveillance_due.try(:text)
      end

      def rx_decision
        document.admin.rx_decision
      end
    end
  end
end
