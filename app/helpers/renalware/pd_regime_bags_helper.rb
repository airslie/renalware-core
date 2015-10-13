module Renalware
  module PDRegimeBagsHelper

    def highlight_days_invalid(pd_regime_bag)
      if pd_regime_bag.errors.include?(:days)
        "validate-days-of-week"
      else
        nil
      end
    end

    def highlight_add_bag_invalid(pd_regime)
      if pd_regime.errors.include?(:pd_regime_bags)
        "validate-add-min-bag"
      else
        nil
      end
    end

  end
end
