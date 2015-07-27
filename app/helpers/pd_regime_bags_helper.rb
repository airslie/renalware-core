module PdRegimeBagsHelper

  def highlight_days_invalid(pd_regime_bag, days)
    if pd_regime_bag.errors.include?(:days)
      "days-of-week"
    else
      nil
    end
  end

end