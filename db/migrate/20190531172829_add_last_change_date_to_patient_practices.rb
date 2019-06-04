class AddLastChangeDateToPatientPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_practices, :last_change_date, :date

    # Here we are moving away from using a deleted_at/acts_as_paranoid approach to hiding practices
    # to just having an #active boolean flag - this more closely emulates the output of the NHS
    # Organisation Data Service (ODS) API which returns Status = Active ot Status = Inactive.
    # Because we are doing some data migration here also, we need to manually handle the rollback.
    reversible do |direction|
      direction.up do
        add_column :patient_practices, :active, :boolean, default: true, index: true
        connection.execute(
          "update renalware.patient_practices set active = false where deleted_at is not null;"
        )
        remove_column :patient_practices, :deleted_at, :datetime
      end
      direction.down do
        add_column :patient_practices, :deleted_at, :datetime, index: true
        connection.execute(
          "update renalware.patient_practices set deleted_at = '2000-01-01' where active = false;"
        )
        remove_column :patient_practices, :active, :boolean
      end
    end
  end
end
