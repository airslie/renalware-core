class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :name,        null: false
      t.string :email
      t.string :code,        null: false

      t.timestamps null: false
    end

    create_table :doctors_practices, id: false do |t|
      t.references :doctor, :practice
    end

    add_index :doctors_practices, [:doctor_id, :practice_id], name: 'index_doctors_practices'
  end
end
