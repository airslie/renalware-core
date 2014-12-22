class CreateModalityCodes < ActiveRecord::Migration
  def change
    create_table :modality_codes do |t|
      t.string :code
      t.string :name
      t.string :site
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
