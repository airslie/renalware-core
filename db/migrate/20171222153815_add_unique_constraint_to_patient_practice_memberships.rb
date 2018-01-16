class AddUniqueConstraintToPatientPracticeMemberships < ActiveRecord::Migration[5.1]
  def change
    add_index :patient_practice_memberships,
              [:practice_id, :primary_care_physician_id],
              unique: true,
              name: "idx_practice_membership"
  end
end
