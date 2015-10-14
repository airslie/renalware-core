class CreatePDRegimeBags < ActiveRecord::Migration
  def change
    create_table :pd_regime_bags do |t|
      t.integer :pd_regime_id
      t.integer :bag_type_id
      t.integer :volume
      t.integer :per_week
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday
      t.boolean :sunday
      t.timestamps null: false
    end
  end
end
