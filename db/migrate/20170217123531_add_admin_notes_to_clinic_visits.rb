class AddAdminNotesToClinicVisits < ActiveRecord::Migration[5.0]
  def change
    add_column :clinic_visits, :admin_notes, :text, null: true
  end
end
