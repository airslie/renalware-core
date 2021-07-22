# frozen_string_literal: true

module Renalware
  log "Adding System Nag Definitions" do
    System::NagDefinition.create!(
      scope: :patient,
      description: "Nag if no clinical frailty score recorded in the last 1 year",
      title: "CFS",
      hint: "Please update the Clinical Frailty Score",
      sql_function_name: "patient_nag_clinical_frailty_score",
      relative_link: "patients/:id/events",
      importance: 2
    )
  end
end
