class CreateRegimeTerminations < ActiveRecord::Migration[4.2]
  def change
    create_table :pd_regime_terminations do |t|
      t.date :terminated_on, null: false
      t.references :regime, index: true, null: false
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :pd_regime_terminations, :pd_regimes, column: :regime_id
    add_foreign_key :pd_regime_terminations, :users, column: :created_by_id
    add_foreign_key :pd_regime_terminations, :users, column: :updated_by_id
  end
end
