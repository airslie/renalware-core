module Renalware
  log '--------------------Adding Transplants Registration Statuses--------------------'

  statuses = [
    [:active, "Active"],
    [:suspended, "Suspended"],
    [:transplanted, "Transplanted"],
    [:live_transplanted, "Live transplanted"],
    [:off_by_patient, "Off by patient request"],
    [:not_eligible, "Not eligible for NHS Tx"],
    [:unfit_reconsider, "Unfit (not listed -- reconsider)"],
    [:unfit_permanent, "Unfit (not listed -- permanent)"],
    [:working_up, "X - working up"],
    [:working_up_lrf, "X - working up LRF"],
    [:not_for_work_up, "Not for work up - eGFR too high"],
    [:workup_complete, "Workup complete - low creat"],
    [:transfer_out, "Transfer Out"],
    [:died, "Died"]
  ]

  statuses.each_with_index do |status, index|
    Transplants::RegistrationStatusDescription.create!(
      code: status[0],
      name: status[1],
      position: index*10
    )
  end
end