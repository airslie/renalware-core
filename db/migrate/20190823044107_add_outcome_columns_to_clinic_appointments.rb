class AddOutcomeColumnsToClinicAppointments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :clinic_appointments, :outcome_notes, :text
      add_column :clinic_appointments, :dna_notes, :text
    end
  end
end
