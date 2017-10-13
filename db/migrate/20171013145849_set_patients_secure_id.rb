class SetPatientsSecureId < ActiveRecord::Migration[5.1]
  def change
    remove_column :patients, :secure_id, :string
    add_column :patients, :secure_id, :uuid, default: 'uuid_generate_v4()', null: false
    add_index :patients, :secure_id, using: :btree, unique: true

    reversible do |direction|
      direction.up do
        ActiveRecord::Base.connection.execute(
          "DROP FUNCTION IF EXISTS generate_secure_id(integer); \
           DROP FUNCTION IF EXISTS generate_patient_secure_id();"
        )
      end
      # down (reinstating the 2 functions) is not implemented...
    end
  end
end
