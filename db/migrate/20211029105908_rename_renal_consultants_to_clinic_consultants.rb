class RenameRenalConsultantsToClinicConsultants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      # Houskeeping - not sure where this column came from - an accidental relic?
      remove_column :renal_consultants, :renal_consultants, :dateime

      # Now rename the table
      rename_table :renal_consultants, :clinic_consultants
    end
  end
end
