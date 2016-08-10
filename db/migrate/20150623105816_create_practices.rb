class CreatePractices < ActiveRecord::Migration
  def change
    create_table :doctor_practices do |t|
      t.string :name,        null: false
      t.string :email
      t.string :code,        null: false

      t.timestamps null: false
    end

    create_table :doctor_doctors_practices, id: false do |t|
      t.references :doctor, :practice
    end

    add_index :doctor_doctors_practices, [:doctor_id, :practice_id], name: 'index_doctors_practices'
  end
end
