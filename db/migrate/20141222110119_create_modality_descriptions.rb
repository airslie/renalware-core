class CreateModalityDescriptions < ActiveRecord::Migration
  def change
    create_table :modality_descriptions do |t|
      t.string :system_code
      t.string :name, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
