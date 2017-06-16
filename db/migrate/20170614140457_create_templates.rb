class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :system_templates do |t|
      t.string :name, null: false, index: true
      t.string :title, null: true
      t.string :description, null: false
      t.text :body, null: false
    end
  end
end
