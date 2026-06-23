class ValidateFixedNumberOfDosesAllowsOneOnPrescriptions < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      validate_check_constraint(
        :medication_prescriptions,
        name: "medication_prescriptions_fixed_number_of_doses_check"
      )
    end
  end
end
