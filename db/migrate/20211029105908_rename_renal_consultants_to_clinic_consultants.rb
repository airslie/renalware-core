class RenameRenalConsultantsToClinicConsultants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      rename_table "renal_consultants", "clinic_consultants"
    end
  end
end
