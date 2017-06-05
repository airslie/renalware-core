module Renalware
  module Clinical
    class DryWeightPresenter < DumbDelegator
      def assessed_on
        ::I18n.l(super)
      end
    end
  end
end
