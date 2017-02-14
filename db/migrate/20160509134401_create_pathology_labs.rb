class CreatePathologyLabs < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_labs do |t|
      t.string :name, null: false
    end
  end
end
