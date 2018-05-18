# frozen_string_literal: true

module Renalware
  log "Adding Sample System Messages" do
    return if System::Message.count > 0
    # An active message - it will displayed on the login page
    System::Message.create!(
      title: "Scheduled Maintenance",
      body: "<div>Please be aware the system will be down between 1pm and 3pm on Sunday "\
            "for maintenance.</div>",
      severity: :default,
      display_from: Date.parse("2018-05-15"),
      display_until: nil
    )
    # An inactive message - not displayed as finished in the past
    System::Message.create!(
      title: "HD Session Reminder",
      body: "<div>Please remember to sign-off any outstanding HD sessions before the "\
            "end of the month.</div>",
      severity: :info,
      display_from: Date.parse("2018-04-25"),
      display_until: Time.zone.parse("2018-04-30 13:59:00")
    )
  end
end
