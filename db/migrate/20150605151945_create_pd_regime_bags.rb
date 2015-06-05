class CreatePdRegimeBags < ActiveRecord::Migration
  def change
    create_table :pd_regime_bags do |t|

      t.timestamps null: false
    end
  end
end
