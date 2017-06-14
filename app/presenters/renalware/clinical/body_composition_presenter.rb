module Renalware
  module Clinical
    class BodyCompositionPresenter < DumbDelegator
      def assessed_on
        ::I18n.l(super)
      end
    end
  end
end
