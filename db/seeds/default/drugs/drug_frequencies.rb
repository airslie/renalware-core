# frozen_string_literal: true

require "./db/seeds/seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding Drug Frequencies" do
    [
      ["daily", "Daily"],
      ["2_times_daily", "2 times daily"],
      ["3_times_daily", "3 times daily"],
      ["4_times_daily", "4 times daily"],
      ["5_times_daily", "5 times daily"],
      ["daily_at_night", "Daily at night"],
      ["daily_each_morning", "Daily each morning"],
      ["2_times_weekly", "2 times weekly"],
      ["3_times_weekly", "3 times weekly"],
      ["weekly", "Weekly"],
      ["every_2_weeks", "Every 2 weeks"],
      ["every_3_weeks", "Every 3 weeks"],
      ["every_4_weeks", "Every 4 weeks"],
      ["every_3_months", "Every 3 months"],
      ["as_required", "As required"]
    ].each do |(name, title)|
      Drugs::Frequency.find_or_create_by!(name: name, title: title)
    end
  end
end
