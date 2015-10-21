module Renalware
  module PDRegimesHelper

    def tidal_options
      options = []
      tidal = 55
      while tidal < 100
        tidal += 5
        options << tidal
      end
      options
    end

    def default_daily_glucose_average(glucose)
      if glucose.blank?
        0
      else
        glucose
      end
    end

    def capd_apd_scope(regime)
      if regime == "Renalware::CAPDRegime"
        ["CAPD 3 exchanges per day", "CAPD 4 exchanges per day", "CAPD 5 exchanges per day"]
      else
        ["APD Dry Day", "APD Wet Day", "APD Wet day with additional exchange"]
      end
    end

    def capd_apd_title(regime)
      if regime == "Renalware::CAPDRegime"
        "CAPD"
      else
        "APD"
      end
    end

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
end
