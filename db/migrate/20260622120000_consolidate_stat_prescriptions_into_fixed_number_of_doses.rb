class ConsolidateStatPrescriptionsIntoFixedNumberOfDoses < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      remove_check_constraint(
        :medication_prescriptions,
        name: "medication_prescriptions_fixed_number_of_doses_check"
      )

      safety_assured do
        execute <<~SQL.squish
          UPDATE renalware.medication_prescriptions
          SET fixed_number_of_doses = 1, stat = false
          WHERE stat IS TRUE
        SQL
      end

      add_check_constraint(
        :medication_prescriptions,
        "fixed_number_of_doses IS NULL OR fixed_number_of_doses BETWEEN 1 AND 10",
        name: "medication_prescriptions_fixed_number_of_doses_check",
        validate: false
      )
    end
  end

  def down
    within_renalware_schema do
      remove_check_constraint(
        :medication_prescriptions,
        name: "medication_prescriptions_fixed_number_of_doses_check"
      )

      safety_assured do
        execute <<~SQL.squish
          UPDATE renalware.medication_prescriptions
          SET fixed_number_of_doses = NULL, stat = true
          WHERE fixed_number_of_doses = 1
        SQL
      end

      add_check_constraint(
        :medication_prescriptions,
        "fixed_number_of_doses IS NULL OR fixed_number_of_doses BETWEEN 2 AND 10",
        name: "medication_prescriptions_fixed_number_of_doses_check",
        validate: false
      )
    end
  end
end
