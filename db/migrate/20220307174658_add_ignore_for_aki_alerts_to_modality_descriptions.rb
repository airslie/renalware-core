class AddIgnoreForAKIAlertsToModalityDescriptions < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column(
        :modality_descriptions,
        :ignore_for_aki_alerts,
        :boolean,
        null: false,
        default: false,
        comment: "If true, HL7 AKI scores are ignored when the patient has this current modality"
      )
    end
  end
end
