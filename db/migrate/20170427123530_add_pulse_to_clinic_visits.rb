class AddPulseToClinicVisits < ActiveRecord::Migration[5.0]
  def change
    add_column :clinic_visits, :pulse, :integer, null: true
  end
end
