class CreateAKIAlertActions < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :renal_aki_alert_actions do |t|
        t.string :name, null: false, index: :unique
        t.integer :position, null: false, default: 0

        t.timestamps null: false
      end
    end
  end
end
