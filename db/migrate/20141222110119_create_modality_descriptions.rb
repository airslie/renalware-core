class CreateModalityDescriptions < ActiveRecord::Migration
  def change
    create_table :modality_descriptions do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
