class CreatePdRegimes < ActiveRecord::Migration
  def change
    create_table :pd_regimes do |t|

      t.timestamps null: false
    end
  end
end
