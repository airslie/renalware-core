module Renalware
  log '--------------------Adding Transplants Registration Statuses--------------------'

  statuses = [
    "Active",
    "Suspended",
    "Transplanted",
    "Live transplanted",
    "Off by patient request",
    "Not eligible for NHS Tx",
    "Unfit (not listed -- reconsider)",
    "Unfit (not listed -- permanent)",
    "X - working up",
    "X - working up LRF",
    "Not for work up - eGFR too high",
    "Workup complete - low creat",
    "Transfer Out",
    "Died"
  ]

  statuses.each_with_index do |status, index|
    Transplants::RegistrationStatusDescription.create!(
      name: status,
      position: index*10
    )
  end
end