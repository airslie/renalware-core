class AddSecureIdToPatients < ActiveRecord::Migration[5.0]
  def up
    # Note we have to use a proc for the default pg function call otherwise it
    # will insert the function name into the columns..
    add_column :patients,
               :secure_id,
               :string,
               null: false,
               default: -> { "generate_patient_secure_id()" }
    add_index :patients, :secure_id, unique: true
  end

  def down
    remove_index :patients, :secure_id
    remove_column :patients, :secure_id
  end
end
