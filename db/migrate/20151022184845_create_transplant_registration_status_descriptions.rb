class CreateTransplantRegistrationStatusDescriptions < ActiveRecord::Migration
  def change
    create_table :transplant_registration_status_descriptions do |t|
      t.string :code, index: true, null: false
      t.string :name
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
