When(/^Clyde records the medication for Patty$/) do
  record_medication_for(
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP"
  )
end
