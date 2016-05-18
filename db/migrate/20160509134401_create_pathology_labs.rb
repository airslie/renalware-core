class CreatePathologyLabs < ActiveRecord::Migration
  def change
    create_table :pathology_labs do |t|
      t.string :name
    end
  end
end
