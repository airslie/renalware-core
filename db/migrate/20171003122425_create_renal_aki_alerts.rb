class CreateRenalAKIAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :renal_aki_alerts do |t|
      t.references :patient, null: false, foreign_key: true, index: true
      t.text :notes

      t.timestamps null: false
    end
  end
end
