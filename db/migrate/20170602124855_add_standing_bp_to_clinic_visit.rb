class AddStandingBpToClinicVisit < ActiveRecord::Migration[5.0]
  def change
    add_column :clinic_visits, :standing_systolic_bp, :integer, null: true
    add_column :clinic_visits, :standing_diastolic_bp, :integer, null: true
  end
end
