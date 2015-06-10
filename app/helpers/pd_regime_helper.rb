module PdRegimeHelper
  def pd_regime_bags(regime_bags)
    if regime_bags.blank?
      "Unknown"
    else
      formatted_pd_regime_bags(regime_bags)
    end
  end

  def formatted_pd_regime_bags(regime_bags)
    safe_join(regime_bags.map { |rb| formatted_pd_regime_bag(rb) })
  end

  def formatted_pd_regime_bag(regime_bag)
    content_tag(:li, ["Bag type: #{regime_bag.bag_type.description}",
              "Volume: #{regime_bag.volume}ml",
              "No. per week: #{regime_bag.per_week}",
              "Days: #{pd_regime_bag_days(regime_bag)}"].join(', '))
  end

  def pd_regime_bag_days(regime_bag)
    days = []
    Date::DAYNAMES.each_with_index do |day, index|
      days << Date::ABBR_DAYNAMES[index] if regime_bag.send(day.downcase.to_sym)
    end
    days.join(', ')
  end
end