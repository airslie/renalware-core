class AddFieldsToClinicClinics < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_table :clinic_clinics do |t|
        t.datetime :deleted_at, index: true
        t.references :updated_by, foreign_key: { to_table: :users }, index: true
        t.references :created_by, foreign_key: { to_table: :users }, index: true
      end
      change_column_null :clinic_clinics, :user_id, true
    end
  end
end
