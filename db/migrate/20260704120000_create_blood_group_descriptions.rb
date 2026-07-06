class CreateBloodGroupDescriptions < ActiveRecord::Migration[7.1]
  within_renalware_schema do
    def change
      create_table :blood_group_descriptions do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false, index: { unique: true }
        t.integer :position, null: false
        t.boolean :enabled, null: false, default: true
        t.timestamps null: false
      end

      reversible do |dir|
        dir.up do
          safety_assured do
            execute <<~SQL.squish
              INSERT INTO blood_group_descriptions (code, name, position, created_at, updated_at)
              VALUES
                ('A', 'A', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                ('AB', 'AB', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                ('B', 'B', 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
                ('O', 'O', 4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            SQL
          end
        end
      end
    end
  end
end
