class AddFixedNumberOfDosesToPrescriptions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column(
        :medication_prescriptions,
        :fixed_number_of_doses,
        :integer,
        comment: "Can be chosen when administer_on_hd is true. Prescriptions with a fixed " \
                 "number of doses will be marked as terminated automatically once that many " \
                 "HD administrations have been recorded."
      )

      add_check_constraint(
        :medication_prescriptions,
        "fixed_number_of_doses IS NULL OR fixed_number_of_doses BETWEEN 2 AND 10",
        name: "medication_prescriptions_fixed_number_of_doses_check",
        validate: false
      )
    end
  end
end
