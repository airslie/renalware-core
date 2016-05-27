class CreatePathologyLabs < ActiveRecord::Migration
  def change
    create_table :pathology_labs do |t|
      t.string :name, null: false
    end
  end
end
