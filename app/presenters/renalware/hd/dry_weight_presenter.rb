module Renalware
  module HD
    class DryWeightPresenter < DumbDelegator
      def initialize(dry_weight)
        super(dry_weight)
      end

      def assessed_on
        ::I18n.l(super)
      end
    end
  end
end
