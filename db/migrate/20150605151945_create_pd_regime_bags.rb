class CreatePDRegimeBags < ActiveRecord::Migration
  def change
    create_table :pd_regime_bags do |t|
      t.references :pd_regime,  null: false, foreign_key: true
      t.references :bag_type,   null: false, foreign_key: true
      t.integer :volume,        null: false
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
